require_relative '../../dsl/intrinsic_functions'

module Convection
  module Model
    class Template
      class Condition
        include DSL::Helpers

        CONDITIONAL_FUNCTION_SYNTAX_MAP =
          { fn_and: 'Fn::And',
            fn_equals: 'Fn::Equals',
            fn_if: 'Fn::If',
            fn_not: 'Fn::Not',
            fn_or: 'Fn::Or' }.freeze

        attr_reader :condition
        attr_reader :template

        CONDITIONAL_FUNCTION_SYNTAX_MAP.keys.each do |conditional_function|
          define_method(conditional_function) do |*args|
            @condition = ConditionalFunction.new conditional_function, args
          end
        end

        def initialize(name, parent)
          @name = name
          @template = parent.template
        end

        def render
          condition.render
        end

        class ConditionalFunction
          def initialize(function_name, arg_array)
            @function_name = function_name
            @function_arguments = arg_array
          end

          def render
            rendered_values = Array(@function_arguments).map do |function_arg|
              function_arg.respond_to?(:render) ? function_arg.render : function_arg
            end

            { CONDITIONAL_FUNCTION_SYNTAX_MAP[@function_name] => rendered_values }
          end
        end
      end
    end
  end
end
