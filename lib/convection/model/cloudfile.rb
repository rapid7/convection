require_relative '../control/stack'
require_relative '../dsl/helpers'
require_relative '../model/attributes'
require_relative '../model/template'
require 'Benchmark'
require 'Thread'

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
      attribute :retry_limit
      attribute :thread_count


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
        options[:retry_limit] = retry_limit

        @stacks[stack_name] = Control::Stack.new(stack_name, template, options, &block)
        @deck << @stacks[stack_name]
      end

      def stack_group(group_name, group_list)
        @stack_groups[group_name] = group_list
      end

      def init_threads(count)
        @thread_count = count
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
        @thread_count ||=2
        instance_eval(IO.read(cloudfile), cloudfile, 1)
        work_q = Queue.new
        @deck.each { |stack| work_q.push stack }
        workers = (0...@thread_count).map do
          Thread.new do
            until work_q.empty?
              stack = work_q.pop(true)
              stack.status
              stack.template_info if stack.exist?
            end
          end
        end
        workers.map(&:join)
      end
    end
  end
end
