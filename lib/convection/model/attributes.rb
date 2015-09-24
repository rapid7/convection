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
        @stacks.include?(stack.to_s) && @stacks[stack.to_s].include?(key.to_s)
      end

      def get(stack, key, default = nil)
        fail ArgumentError, "Attempted to reference an undefined attribute, #{key}, in stack #{stack} ", caller unless include?(stack, key) || default
        include?(stack, key) ? @stacks[stack.to_s][key.to_s] : default
      end

      def set(stack, key, value)
        @stacks[stack.to_s][key.to_s] = value
      end

      def load_outputs(stack)
        @stacks[stack.name.to_s].outputs = stack.outputs
      end

      def load_resources(stack)
        @stacks[stack.name.to_s].resources = stack.attribute_mapping_values
      end
    end
  end
end
