module Convection
  module DSL
    ##
    # Template DSL
    ##
    module Helpers
      def attribute(name)
        define_method(name) do |value = nil|
          instance_variable_set("@#{ name }", value) unless value.nil?
          instance_variable_get("@#{ name }")
        end
      end
    end
  end
end
