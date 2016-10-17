require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticloadbalancingv2-listenerrule-conditions.html
        # ELBV2 ListenerRule Condition Type
        class ELBV2ListenerRuleCondition < ResourceProperty
          # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_RuleCondition.html
          property :field_name, 'Field'
          property :values, 'Values', :type => :list
        end
      end
    end
  end
end
