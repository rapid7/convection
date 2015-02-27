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

          def initialize(*args)
            super
            type 'AWS::ElasticLoadBalancing::LoadBalancer'
            @app_cookie_stickiness_policy = []
            @instances = []
            @lb_cookie_stickiness_policy = []
            @listeners = []
            @policies = []
            @security_groups = []
            @subnets = []
          end

          property :access_logging_policy, 'AccessLoggingPolicy'
          property :app_cookie_stickiness_policy, 'AppCookieStickinessPolicy', :array
          property :lb_cookie_stickiness_policy, 'LBCookieStickinessPolicy', :array
          property :availability_zone, 'AvailabilityZones', :array
          property :connection_draining_policy, 'ConnectionDrainingPolicy'
          property :connection_settings, 'ConnectionSettings'
          property :cross_zone, 'CrossZone'
          property :health_check, 'HealthCheck'
          property :instance, 'Instances', :array
          property :load_balancer_name, 'LoadBalancerName'
          property :listener, 'Listeners', :array
          property :policy, 'Policies', :array
          property :scheme, 'Scheme'
          property :security_group, 'SecurityGroups', :array
          property :subnet, 'Subnets', :array

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def elb(name, &block)
        r = Model::Template::Resource::ELB.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
