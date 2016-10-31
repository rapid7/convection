require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticloadbalancingv2-targetgroup-targetgroupattributes.html
        # ELBV2 TargetGroup TargetGroupAttribute Type}
        class ELBV2TargetGroupAttribute < ResourceProperty
          # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_TargetGroupAttribute.html
          property :key, 'Key'
          property :value, 'Value'
        end
      end
    end
  end
end
