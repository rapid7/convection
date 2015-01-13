require_relative '../dsl/helpers'
require_relative '../dsl/intrinsic_functions'
require 'json'

module Convection
  module DSL
    ##
    # Template DSL
    ##
    module Template
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

      # def condition(name, &block)
      #   c = Model::Template::Condition.new
      #   c.instance_exec(&block) if block
      #
      #   conditions[name] = c
      # end

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
    # Template container class
    ##
    class Template
      extend DSL::Helpers

      include DSL::IntrinsicFunctions
      include DSL::Template

      DEFAULT_VERSION = '2010-09-09'

      attribute :version
      attribute :description
      attribute :region

      attr_reader :stack
      attr_reader :parameters
      attr_reader :mappings
      attr_reader :conditions
      attr_reader :resources
      attr_reader :outputs

      def initialize(stack = Model::Stack.new('default', self), &block)
        @definition = block
        @stack = stack

        @version = DEFAULT_VERSION
        @description = ''

        @parameters = Collection.new
        @mappings = Collection.new
        @conditions = Collection.new
        @resources = Collection.new
        @outputs = Collection.new
      end

      def render(stack = nil)
        ## Instantiate a new template with the definition block and an other stack
        return Template.new(stack, &@definition).render unless stack.nil?

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

      def to_json(stack = nil)
        JSON.pretty_generate(render(stack))
      end
    end
  end
end

require_relative 'template/parameter'
require_relative 'template/mapping'
# require_relative 'template/condition'
require_relative 'template/resource'
require_relative 'template/output'
