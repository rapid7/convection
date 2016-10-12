require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticloadbalancingv2-listenerrule-actions.html
        # ELBV2 ListenerRule Action Type}
        class ELBV2ListenerRuleAction < ResourceProperty
          # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_Action.html
          property :target_group_arn, 'TargetGroupArn'
          property :type, 'Type'
        end
      end
    end
  end
end
