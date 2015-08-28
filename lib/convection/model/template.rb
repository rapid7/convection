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
        stack = render(stack_)

        #bytesize
        json = JSON.generate(stack)
        template_bytesize = json.bytesize
        cf_max_bytesize = 51200
        if template_bytesize > cf_max_bytesize
          Kernel.abort("Error: Excessive Template Size (#{template_bytesize}) Max= #{cf_max_bytesize}")
        end

        #description characters
        description_bytesize = stack['Description'].bytesize
        cf_max_description_bitesize = 1024
        if description_bytesize > cf_max_description_bitesize
          Kernel.abort("Error: Excessive Description Size (#{description_bytesize}) Max= #{cf_max_description_bitesize}")
        end

        #resource count
        number_of_resources = stack["Resources"].count
        cf_max_resources = 200
        if number_of_resources > cf_max_resources
          Kernel.abort("Error: Excessive Number of Resources (#{number_of_resources}) Max= #{cf_max_resources}")
        end

        #parameter count
        number_of_parameters = stack['Parameters'].count
        cf_max_parameters = 60
        if number_of_parameters > cf_max_parameters
          Kernel.abort("Error: Excessive Number of Parameters (#{number_of_parameters}) Max= #{cf_max_parameters}")
        end

        #parameter name characters
        largest_parameter_name = ((stack['Parameters'].keys).max)
        if largest_parameter_name == nil
          largest_parameter_name = ""
        end
        parameter_name_characters = largest_parameter_name.length
        cf_max_parameter_name_characters = 255
        if parameter_name_characters > cf_max_parameter_name_characters
          Kernel.abort("Error: Parameter Name #{largest_parameter_name} has too many characters (#{parameter_name_characters}) Max= #{cf_max_parameter_name_characters}")
        end

        #mappings count
        number_of_mappings = stack ['Mappings'].count
        cf_max_mappings = 100
        if number_of_mappings > cf_max_mappings
          Kernel.abort("Error: Excessive Number of Mappings (#{number_of_mappings}) Max= #{cf_max_mappings}")
        end

        #outputs count
        number_of_outputs = stack['Outputs'].count
        cf_max_outputs = 60
        if number_of_outputs > cf_max_outputs
          Kernel.abort("Error: Excessive Number of Outputs (#{number_of_outputs}) Max= #{cf_max_outputs}")
        end

        #output name characters
        largest_output_name = ((stack['Outputs'].keys).max)
        if largest_output_name == nil
          largest_output_name = ""
        end
        output_name_characters = largest_output_name.length
        cf_max_output_name_characters = 255
        if output_name_characters > cf_max_output_name_characters
          Kernel.abort("Error: Output Name #{largest_output_name} has too many characters (#{output_name_characters}) Max= #{cf_max_output_name_characters}")
        end

        return JSON.generate(stack) unless pretty
        JSON.pretty_generate(stack)
      end
    end
  end
end

require_relative 'template/parameter'
require_relative 'template/mapping'
require_relative 'template/condition'
require_relative 'template/resource'
require_relative 'template/output'
