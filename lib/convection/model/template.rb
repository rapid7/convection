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
      extend DSL::Helpers

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
    # Add generic diff(other) and properties to Hash
    ##
    class ::Hash
      ## Use flattened properties to calculate a diff
      def diff(other = {})
        our_properties = properties
        their_properties = other.properties

        (our_properties.keys + their_properties.keys).uniq.inject({}) do |memo, key|
          next memo if our_properties[key] == their_properties[key]

          memo[key] = [our_properties[key], their_properties[key]]
          memo
        end
      end

      ## Recursivly flatten a hash into 1st order key/value pairs
      def properties(memo = {}, path = '')
        keys.each do |key|
          if self[key].is_a?(Hash)
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
          'Resources' => resources.map(&:render),
          'Outputs' => outputs.map(&:render)
        }
      end

      def diff(other, stack_ = nil)
        render(stack_).diff(other).map { |diff| Diff.new(diff[0], *diff[1]) }
      end

      def to_json(stack_ = nil, pretty = false)
        return JSON.generate(render(stack_)) unless pretty
        JSON.pretty_generate(render(stack_))
      end
    end
  end
end

require_relative 'template/parameter'
require_relative 'template/mapping'
require_relative 'template/resource'
require_relative 'template/output'
