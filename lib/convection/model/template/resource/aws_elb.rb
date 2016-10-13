require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElasticLoadBalancing::LoadBalancer
        ##
        class ELB < Resource
          include Model::Mixin::Taggable

          type 'AWS::ElasticLoadBalancing::LoadBalancer', :elb
          property :access_logging_policy, 'AccessLoggingPolicy'
          property :app_cookie_stickiness_policy, 'AppCookieStickinessPolicy', :type => :list
          property :lb_cookie_stickiness_policy, 'LBCookieStickinessPolicy', :type => :list
          property :availability_zone, 'AvailabilityZones', :type => :list
          property :connection_draining_policy, 'ConnectionDrainingPolicy'
          property :connection_settings, 'ConnectionSettings'
          property :cross_zone, 'CrossZone'
          property :health_check, 'HealthCheck'
          property :instance, 'Instances', :type => :list
          property :load_balancer_name, 'LoadBalancerName'
          property :listener, 'Listeners', :type => :list
          property :policy, 'Policies', :type => :list
          property :scheme, 'Scheme'
          property :security_group, 'SecurityGroups', :type => :list
          alias_method :security_groups, :security_group
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
