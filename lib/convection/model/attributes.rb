module Convection
  module Model
    ##
    # Manage parameters and attributes across stacks
    ##
    class Attributes
      class Stack
        attr_accessor :resources
        attr_accessor :outputs
        attr_reader :parameters

        def initialize
          @resources = {}
          @outputs = {}
          @parameters = {}
        end

        def include?(key)
          @parameters.include?(key) || @outputs.include?(key) || @resources.include?(key)
        end

        def [](key)
          @parameters[key.to_s] || @outputs[key.to_s] || @resources[key.to_s]
        end

        def []=(key, value)
          @parameters[key.to_s] = value
        end
      end

      attr_reader :stacks

      def initialize
        @stacks = Hash.new do |hash, key|
          hash[key] = Stack.new
        end
      end

      def include?(stack, key)
        @stacks.include?(stack) && @stacks[stack].include?(key)
      end

      def get(stack, key)
        include?(stack, key) ? @stacks[stack.to_s][key.to_s] : fail(ArgumentError, "Attempted to reference an undefined attribute!", caller)
      end

      def set(stack, key, value)
        @stacks[stack.to_s][key.to_s] = value
      end

      def stack(stack)
        @stacks[stack.name.to_s].resources = stack.resources
        @stacks[stack.name.to_s].outputs = stack.outputs
      end
    end
  end
end
