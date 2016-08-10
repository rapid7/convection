require_relative '../control/stack'
require_relative '../dsl/helpers'
require_relative '../model/attributes'
require_relative '../model/template'
require 'pp'
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

        time = Benchmark.realtime do
        @stacks[stack_name] = Control::Stack.new(stack_name, template, options, &block)
        end
        puts "Stack initialization #{stack_name} #{time*1000} milliseconds"
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
        time = Benchmark.realtime do
        @attributes = Model::Attributes.new
        @stacks = {}
        @deck = []
        @stack_groups = {}

        time = Benchmark.realtime do
        puts "Before instance eval"
        instance_eval(IO.read(cloudfile), cloudfile, 1)
        end
        puts "Time elapsed in instance eval of cloudfile #{time*1000} milliseconds"

        work_q = Queue.new
        @deck.each{|stack| work_q.push stack }
        workers = (0...2).map do
          Thread.new do
            begin
              while stack = work_q.pop(true)
                puts "resolving #{stack.name}"
                stack.resolve_status
                stack.resolver_two if stack.exist?

                puts "resolve finished #{stack.name}"
              end
            rescue ThreadError
            end
          end
        end;
        workers.map(&:join);

=begin
        pp @deck
        pool = ThreadPool.new(5)
          @deck.each do |stack|
            puts stack.name
            pool.process {
              puts "resolving #{stack.name}"
              stack.resolver
            }
          end
        pool.shutdown
=end
        end
        puts "Time elapsed in initialize of cloudfile #{time*1000} milliseconds"

      end
    end
  end
end
