module Convection
  module Model
    module Mixin
      ##
      # Add condition helpers
      ##
      module Conditional
        def condition(setter = nil)
          @condition = setter unless setter.nil?
          @condition
        end

        def render_condition(resource)
          resource.tap do |r|
            r['Condition'] = condition unless condition.nil?
          end
        end
      end
    end
  end
end
