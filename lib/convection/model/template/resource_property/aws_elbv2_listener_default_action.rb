require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticloadbalancingv2-listener-defaultactions.html
        # ELBV2 Listener DefaultAction type
        class ELBV2ListenerDefaultAction < ResourceProperty
          property :target_group_arn, 'TargetGroupArn'
          property :type, 'Type'
        end
      end
    end
  end
end
