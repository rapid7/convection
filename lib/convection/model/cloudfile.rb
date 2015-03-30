require_relative '../control/stack'
require_relative '../dsl/helpers'
require_relative '../model/attributes'
require_relative '../model/template'

module Convection
  module DSL
    ##
    # DSL for Cloudfile
    ##
    module Cloudfile
      include DSL::Helpers

      attribute :name
      attribute :region

      ## Helper to define a template in-line
      def template(*args, &block)
        Model::Template.new(*args, &block)
      end

      def attribute(stack, key, value)
        @attributes.set(stack, key, value)
      end

      def stack(stack_name, template, options = {})
        options[:region] ||= region
        options[:cloud] = name
        options[:attributes] = attributes

        @stacks[stack_name] = Control::Stack.new(stack_name, template, options)
        @deck << @stacks[stack_name]
      end
    end
  end

  module Model
    ##
    # Define your Clouds
    ##
    class Cloudfile
      include DSL::Cloudfile

      attr_reader :attributes
      attr_reader :stacks
      attr_reader :deck

      def initialize(cloudfile)
        @attributes = Model::Attributes.new
        @stacks = {}
        @deck = []

        instance_eval(IO.read(cloudfile), cloudfile, 1)
      end
    end
  end
end
