require_relative '../dsl/helpers'
require_relative '../dsl/intrinsic_functions'
require_relative './diff'
require_relative './exceptions.rb'
require 'json'

module Convection
  module DSL
    ##
    # Template DSL
    ##
    module Template
      ##
      # Container for DSL interfaces
      ##
      module Resource
        class << self
          ## Wrap private define_method
          def attach_resource(name, klass)
            define_method(name) do |rname, &block|
              resource = klass.new(rname, self)
              resource.instance_exec(&block) if block

              resources[rname] = resource
            end
          end
        end
      end

      include DSL::Helpers
      include DSL::Template::Resource

      CF_MAX_BYTESIZE = 51_200
      CF_MAX_DESCRIPTION_BYTESIZE = 1_024
      CF_MAX_MAPPING_ATTRIBUTE_NAME = 255
      CF_MAX_MAPPING_ATTRIBUTES = 30
      CF_MAX_MAPPING_NAME = 25
      CF_MAX_MAPPINGS = 100
      CF_MAX_OUTPUT_NAME_CHARACTERS = 255
      CF_MAX_OUTPUTS = 60
      CF_MAX_PARAMETER_NAME_CHARACTERS = 255
      CF_MAX_PARAMETERS = 60
      CF_MAX_PARAMETER_VALUE_BYTESIZE = 4_086
      CF_MAX_RESOURCE_NAME = 255
      CF_MAX_RESOURCES = 200

      attribute :name
      attribute :version
      attribute :description

      def parameter(name, &block)
        pa = Model::Template::Parameter.new(name, self)

        pa.instance_exec(&block) if block
        parameters[name] = pa
      end

      def mapping(name, &block)
        m = Model::Template::Mapping.new(name, self)

        m.instance_exec(&block) if block
        mappings[name] = m
      end

      def condition(name, &block)
        c = Model::Template::Condition.new(name, self)

        c.instance_exec(&block) if block
        conditions[name] = c
      end

      def resource(name, &block)
        r = Model::Template::Resource.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end

      def output(name, &block)
        o = Model::Template::Output.new(name, self)

        o.instance_exec(&block) if block
        outputs[name] = o
      end
    end
  end

  module Model
    ##
    # Mapable hash
    ##
    class Collection < Hash
      def map(no_nil = false, &block)
        result = {}

        each do |key, value|
          res = block.call(value)

          next if no_nil && res.nil?
          next if no_nil && res.is_a?(Array) && res.empty?
          next if no_nil && res.is_a?(Hash) && res.empty?

          result[key] = res
        end

        result
      end
    end

    ##
    # HACK: Add generic diff(other) and properties to Hash and Array
    ##
    class ::Array
      ## Recursivly flatten an array into 1st order key/value pairs
      def properties(memo = {}, path = '')
        each_with_index do |elm, i|
          if elm.is_a?(Hash) || elm.is_a?(Array)
            elm.properties(memo, "#{path}.#{i}")
          else
            memo["#{path}.#{i}"] = elm
          end
        end

        memo
      end
    end

    ##
    # HACK: Add generic diff(other) and properties to Hash and Array
    ##
    class ::Hash
      ## Use flattened properties to calculate a diff
      def diff(other = {})
        our_properties = properties
        their_properties = other.properties

        (our_properties.keys + their_properties.keys).uniq.each_with_object({}) do |key, memo|
          next if (our_properties[key] == their_properties[key] rescue false)

          ## HACK: String/Number/Symbol comparison
          if our_properties[key].is_a?(Numeric) ||
             their_properties[key].is_a?(Numeric) ||
             our_properties[key].is_a?(Symbol) ||
             their_properties[key].is_a?(Symbol)
            next if our_properties[key].to_s == their_properties[key].to_s
          end

          memo[key] = [our_properties[key], their_properties[key]]
        end
      end

      ## Recursivly flatten a hash into 1st order key/value pairs
      def properties(memo = {}, path = '')
        keys.each do |key|
          if self[key].is_a?(Hash) || self[key].is_a?(Array)
            self[key].properties(memo, "#{path}.#{key}")
          else
            memo["#{path}.#{key}"] = self[key]
          end
        end

        memo
      end
    end

    ##
    # Template container class
    ##
    class Template
      include DSL::IntrinsicFunctions
      include DSL::Template

      DEFAULT_VERSION = '2010-09-09'.freeze

      attr_reader :stack
      attr_reader :attribute_mappings

      attr_reader :parameters
      attr_reader :mappings
      attr_reader :conditions
      attr_reader :resources
      attr_reader :outputs

      def template
        self
      end

      def initialize(stack = nil, &block)
        @definition = block

        @stack = stack
        @attribute_mappings = {}

        @version = DEFAULT_VERSION
        @description = ''

        @parameters = Collection.new
        @mappings = Collection.new
        @conditions = Collection.new
        @resources = Collection.new
        @outputs = Collection.new
      end

      def clone(stack_)
        Template.new(stack_, &@definition)
      end

      def execute
        instance_exec(&@definition)
      end

      def render(stack_ = nil)
        ## Instantiate a new template with the definition block and an other stack
        return clone(stack_).render unless stack_.nil?

        execute ## Process the template document

        {
          'AWSTemplateFormatVersion' => version,
          'Description' => description,
          'Parameters' => parameters.map(&:render),
          'Mappings' => mappings.map(&:render),
          'Conditions' => conditions.map(&:render),
          'Resources' => resources.map(&:render),
          'Outputs' => outputs.map(&:render)
        }
      end

      def diff(other, stack_ = nil)
        render(stack_).diff(other).map { |diff| Diff.new(diff[0], *diff[1]) }
      end

      def to_json(stack_ = nil, pretty = false)
        rendered_stack = render(stack_)
        validate(rendered_stack)
        return JSON.generate(rendered_stack) unless pretty
        JSON.pretty_generate(rendered_stack)
      end

      def validate(rendered_stack = nil)
        %w(resources mappings parameters outputs description bytesize).map do |method|
          send("validate_#{method}", rendered_stack)
        end
      end

      def validate_compare(value, cf_max, error)
        limit_exceeded_error(value, cf_max, error) if value > cf_max
      end

      def validate_resources(rendered_stack)
        validate_compare(rendered_stack['Resources'].count,
                         CF_MAX_RESOURCES,
                         ExcessiveResourcesError)

        largest_resource_name = resources.keys.max || ''
        validate_compare(largest_resource_name.length,
                         CF_MAX_RESOURCE_NAME,
                         ExcessiveResourceNameError)
      end

      def validate_mappings(rendered_stack)
        mappings = rendered_stack ['Mappings']
        validate_compare(mappings.count,
                         CF_MAX_MAPPINGS,
                         ExcessiveMappingsError)
        mappings.each do |_, value|
          validate_compare(
            value.count,
            CF_MAX_MAPPING_ATTRIBUTES,
            ExcessiveMappingAttributesError
          )
        end

        mappings.keys.each do |key|
          validate_compare(key.length,
                           CF_MAX_MAPPING_NAME,
                           ExcessiveMappingNameError)
        end

        ## XXX What are we trying to do here @aburke
        mapping_attributes = mappings.values.flat_map do |inner_hash|
          inner_hash.keys.select do |key|
            value = inner_hash[key]
          end
        end

        mapping_attributes.each do |attribute|
          validate_compare(attribute.length,
                           CF_MAX_MAPPING_ATTRIBUTE_NAME,
                           ExcessiveMappingAttributeNameError)
        end
      end

      def validate_parameters(rendered_stack)
        parameters = rendered_stack['Parameters']
        validate_compare(parameters.count,
                         CF_MAX_PARAMETERS,
                         ExcessiveParametersError)
        largest_parameter_name = parameters.keys.max
        largest_parameter_name ||= ''
        validate_compare(largest_parameter_name.length,
                         CF_MAX_PARAMETER_NAME_CHARACTERS,
                         ExcessiveParameterNameError)
        parameters.values.each do |value|
          validate_compare(JSON.generate(value).bytesize,
                           CF_MAX_PARAMETER_VALUE_BYTESIZE,
                           ExcessiveParameterBytesizeError)
        end
      end

      def validate_outputs(rendered_stack)
        outputs = rendered_stack['Outputs']
        validate_compare(outputs.count,
                         CF_MAX_OUTPUTS,
                         ExcessiveOutputsError)
        largest_output_name = outputs.keys.max
        largest_output_name ||= ''
        validate_compare(largest_output_name.length,
                         CF_MAX_OUTPUT_NAME_CHARACTERS,
                         ExcessiveOutputNameError)
      end

      def validate_description(rendered_stack)
        validate_compare(rendered_stack['Description'].bytesize,
                         CF_MAX_DESCRIPTION_BYTESIZE,
                         ExcessiveDescriptionError)
      end

      def validate_bytesize(rendered_stack)
        json = JSON.generate(rendered_stack)
        validate_compare(json.bytesize,
                         CF_MAX_BYTESIZE,
                         ExcessiveTemplateSizeError)
      end
    end
  end
end

require_relative 'template/parameter'
require_relative 'template/mapping'
require_relative 'template/condition'
require_relative 'template/resource'
require_relative 'template/resource_property'
require_relative 'template/resource_attribute'
require_relative 'template/output'
