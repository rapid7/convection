require_relative '../dsl/helpers'
require_relative '../dsl/intrinsic_functions'
require_relative './diff'
require 'json'

module Convection
  module DSL
    ##
    # Template DSL
    ##
    module Template
      include DSL::Helpers

      CF_MAX_BYTESIZE = 51200
      CF_MAX_DESCRIPTION_BYTESIZE = 1024
      CF_MAX_RESOURCES = 200
      CF_MAX_RESOURCE_NAME = 255
      CF_MAX_MAPPINGS = 30
      CF_MAX_MAPPING_NAME = 25
      CF_MAX_MAPPING_ATTRIBUTES = 30
      CF_MAX_MAPPING_ATTRIBUTE_NAME = 255
      CF_MAX_PARAMETERS = 60
      CF_MAX_PARAMETER_VALUE_BYTESIZE = 4086
      CF_MAX_PARAMETER_NAME_CHARACTERS = 255
      CF_MAX_OUTPUTS = 60
      CF_MAX_OUTPUT_NAME_CHARACTERS = 255

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
      def map(&block)
        result = {}

        each do |key, value|
          result[key] = block.call(value)
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

        (our_properties.keys + their_properties.keys).uniq.inject({}) do |memo, key|
          next memo if our_properties[key] == their_properties[key]

          ## HACK: String/Number/Symbol comparison
          if our_properties[key].is_a?(Numeric) ||
             their_properties[key].is_a?(Numeric) ||
             our_properties[key].is_a?(Symbol) ||
             their_properties[key].is_a?(Symbol)
            next memo if our_properties[key].to_s == their_properties[key].to_s
          end

          memo[key] = [our_properties[key], their_properties[key]]
          memo
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

      DEFAULT_VERSION = '2010-09-09'

      attr_reader :stack
      attr_reader :attribute_mappings

      attr_reader :parameters
      attr_reader :mappings
      attr_reader :conditions
      attr_reader :resources
      attr_reader :outputs

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

      def render(stack_ = nil)
        ## Instantiate a new template with the definition block and an other stack
        return clone(stack_).render unless stack_.nil?

        instance_exec(&@definition)
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

        return JSON.generate(render(stack_)) unless pretty
        JSON.pretty_generate(render(stack_))
      end

      def validate(rendered_stack = nil)
        validate_resources(rendered_stack)
        validate_mappings(rendered_stack)
        validate_parameters(rendered_stack)
        validate_outputs(rendered_stack)
        validate_description(rendered_stack)
        validate_bytesize(rendered_stack)

      end

      def validate_resources(rendered_stack = nil)
        resources=rendered_stack["Resources"]
        number_of_resources = resources.count
        if number_of_resources > CF_MAX_RESOURCES
          raise ArgumentError, "Error: Excessive Number of Resources (#{number_of_resources}) Max= #{CF_MAX_RESOURCES}"
        end
        largest_resource_name = resources.keys.max
        if largest_resource_name == nil
          largest_resource_name = ""
        end
        resource_name_characters = largest_resource_name.length
        if  resource_name_characters> CF_MAX_RESOURCE_NAME
          raise ArgumentError, "Error: Resource Name #{largest_resource_name} has too many characters (#{resource_name_characters}) Max=#{CF_MAX_RESOURCE_NAME} "
        end
      end

      def validate_mappings(rendered_stack = nil)
        mappings = rendered_stack ['Mappings']
        number_of_mappings = mappings.count
        if number_of_mappings > CF_MAX_MAPPINGS
          raise ArgumentError, "Error: Excessive Number of Mappings (#{number_of_mappings}) Max= #{CF_MAX_MAPPINGS}"
        end
        mappings.each do |key,value|
          if value.count > CF_MAX_MAPPING_ATTRIBUTES
            raise ArgumentError, "Error: Excessive Number of Mapping Attributes"
          end
        end
        mappings.keys.each do |key|
          if key.length > CF_MAX_MAPPING_NAME
            raise ArgumentError, "Error: Excessive Mapping Name #{key}"
          end
        end
        mapping_attributes = mappings.values.flat_map do |inner_hash|
          inner_hash.keys.select do |key|
            value = inner_hash[key]
          end
        end
        mapping_attributes.each do |attribute|
          if attribute.length > CF_MAX_MAPPING_ATTRIBUTE_NAME
            raise ArgumentError, "Error: Excessive Mapping Attribute Name #{attribute}"
          end
        end
      end

      def validate_parameters(rendered_stack = nil)
        parameters= rendered_stack['Parameters']
        number_of_parameters = parameters.count
        if number_of_parameters > CF_MAX_PARAMETERS
          raise ArgumentError, "Error: Excessive Number of Parameters (#{number_of_parameters}) Max= #{CF_MAX_PARAMETERS}"
        end
        largest_parameter_name = parameters.keys.max
        if largest_parameter_name == nil
          largest_parameter_name = ""
        end
        parameter_name_characters = largest_parameter_name.length
        if parameter_name_characters > CF_MAX_PARAMETER_NAME_CHARACTERS
          raise ArgumentError, "Error: Parameter Name #{largest_parameter_name} has too many characters (#{parameter_name_characters}) Max= #{CF_MAX_PARAMETER_NAME_CHARACTERS}"
        end
        parameters.values.each do |value|
          parameter_in_json = JSON.generate(value)
          if parameter_in_json.bytesize > CF_MAX_PARAMETER_VALUE_BYTESIZE
            raise ArgumentError, "Error: Excessive Parameter Size #{value}"
          end
        end
      end

      def validate_outputs(rendered_stack = nil)
        outputs = rendered_stack['Outputs']
        number_of_outputs = outputs.count
        if number_of_outputs > CF_MAX_OUTPUTS
          raise ArgumentError, "Error: Excessive Number of Outputs (#{number_of_outputs}) Max= #{CF_MAX_OUTPUTS}"
        end
        largest_output_name = outputs.keys.max
        if largest_output_name == nil
          largest_output_name = ""
        end
        output_name_characters = largest_output_name.length
        if output_name_characters > CF_MAX_OUTPUT_NAME_CHARACTERS
          raise ArgumentError, "Error: Output Name #{largest_output_name} has too many characters (#{output_name_characters}) Max= #{CF_MAX_OUTPUT_NAME_CHARACTERS}"
        end
      end

      def validate_description(rendered_stack = nil)
        description_bytesize = rendered_stack['Description'].bytesize
        if description_bytesize > CF_MAX_DESCRIPTION_BYTESIZE
          raise ArgumentError, "Error: Excessive Description Size (#{description_bytesize}) Max= #{CF_MAX_DESCRIPTION_BYTESIZE}"
        end
      end

      def validate_bytesize(rendered_stack = nil)
        json = JSON.generate(rendered_stack)
        template_bytesize = json.bytesize
        if template_bytesize > CF_MAX_BYTESIZE
          raise ArgumentError, "Error: Excessive Template Size (#{template_bytesize}) Max= #{CF_MAX_BYTESIZE}"
        end
      end



    end
  end
end

require_relative 'template/parameter'
require_relative 'template/mapping'
require_relative 'template/condition'
require_relative 'template/resource'
require_relative 'template/output'
