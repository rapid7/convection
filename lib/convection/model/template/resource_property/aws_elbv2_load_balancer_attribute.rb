require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticloadbalancingv2-loadbalancer-loadbalancerattributes.html
        # Elastic Load Balancing LoadBalancer LoadBalancerAttributes Type}
        class ELBV2LoadBalancerAttribute < ResourceProperty
          # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_LoadBalancerAttribute.html
          property :key, 'Key'
          property :value, 'Value'
        end
      end
    end
  end
end
