require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticloadbalancingv2-targetgroup-targetdescription.html
        # ELBV2 TargetGroup TargetDescription Type}
        class ELBV2TargetGroupTargetDescription < ResourceProperty
          property :id, 'Id'
          property :port, 'Port'
        end
      end
    end
  end
end
