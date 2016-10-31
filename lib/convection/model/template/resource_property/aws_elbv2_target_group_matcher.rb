require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticloadbalancingv2-targetgroup-matcher.html
        # ELBV2 TargetGroup Matcher Type}
        class ELBV2TargetGroupMatcher < ResourceProperty
          property :http_code, 'HttpCode'
        end
      end
    end
  end
end
