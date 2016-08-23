require_relative '../control/stack'
require_relative '../dsl/helpers'
require_relative '../model/attributes'
require_relative '../model/template'
require 'thread'

module Convection
  module DSL
    ##
    # DSL for Cloudfile
    ##
    module Cloudfile
      include DSL::Helpers

      attribute :name
      attribute :region
      attribute :splay

      ## Helper to define a template in-line
      def template(*args, &block)
        Model::Template.new(*args, &block)
      end

      def attribute(stack, key, value)
        @attributes.set(stack, key, value)
      end

      # Adds a stack with the provided options to the list of stacks.
      #
      # @see Convection::Control::Stack#initialize
      def stack(stack_name, template, options = {}, &block)
        options[:region] ||= region
        options[:cloud] = name
        options[:attributes] = attributes

        @stacks[stack_name] = Control::Stack.new(stack_name, template, options, &block)
        @deck << @stacks[stack_name]
      end

      def stack_group(group_name, group_list)
        @stack_groups[group_name] = group_list
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
      attr_reader :stack_groups

      def initialize(cloudfile)
        @attributes = Model::Attributes.new
        @stacks = {}
        @deck = []
        @stack_groups = {}

        instance_eval(IO.read(cloudfile), cloudfile, 1)

        work_q = Queue.new
        @deck.each{|stack| work_q.push stack }
        workers = (0...2).map do
          Thread.new do
            begin
              while stack = work_q.pop(true)
                stack.resolve_status
                stack.resolver if stack.exist?
              end
            rescue ThreadError
            end
          end
        end;
        workers.map(&:join);
      end
    end
  end
end
