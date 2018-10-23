require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticloadbalancingv2-loadbalancer-subnetmapping.html
        # Elastic Load Balancing LoadBalancer SubnetMapping Type}
        class ELBV2LoadBalancerSubnetMapping < ResourceProperty
          # https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_SubnetMapping.html
          property :subnet_id, 'SubnetId'
          property :allocation_id, 'AllocationId'
        end
      end
    end
  end
end
