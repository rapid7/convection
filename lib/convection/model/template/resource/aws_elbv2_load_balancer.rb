require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElasticLoadBalancingV2::LoadBalancer
        ##
        class ELBV2LoadBalancer < Resource
          include Model::Mixin::Taggable

          type 'AWS::ElasticLoadBalancingV2::LoadBalancer', :elbv2_load_balancer
          property :load_balancer_attributes, 'LoadBalancerAttributes', :type => :list
          property :name, 'Name'
          property :scheme, 'Scheme'
          property :security_group, 'SecurityGroups', :type => :list
          property :subnet, 'Subnets', :type => :list
          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
