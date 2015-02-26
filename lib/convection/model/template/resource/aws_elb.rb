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

          def access_logging_policy(value)
            property('AccessLoggingPolicy', value)
          end
          
          def app_cookie_stickiness_policy(value)
            @app_cookie_stikiness_policy << value
          end
          
          def availability_zones(value)
            property('AvailabilityZones', value)
          end
          
          def connection_draining_policy(value)
            property('ConnectionDrainingPolicy', value)
          end
          
          def connection_settings(value)
            property('ConnectionSettings', value)
          end
          
          def cross_zone(value)
            property('CrossZone', value)
          end

          def health_check(value)
            property('HealthCheck', value)
          end
          
          def instances(value)
            @instances << value
          end
          
          def lb_cookie_stickiness_policy(value)
            @lb_cookie_stickiness_policy << value
          end
          
          def load_balancer_name(value)
            property('LoadBalancerName', value)
          end
          
          def listeners(value)
            @listeners << value
          end
          
          def policies(value)
            @policies << value
          end
          
          def scheme(value)
            property('Scheme', value)
          end
          
          def security_groups(value)
            @security_groups << value
          end
          
          def subnets(value)
            property :subnets, 'Subnets', :array
          end
          
         def render(*args)
            super.tap do |resource|
              render_tags(resource)
              @properties['AppCookieStickinessPolicy'] = @app_cookie_stickiness_policy unless @app_cookie_stickiness_policy.empty?
              @properties['Instances'] = @instances unless @instances.empty?
              @properties['LBCookieStickinessPolicy'] = @lb_cookie_stickiness_policy unless @lb_cookie_stickiness_policy.empty?
              @properties['Listeners'] = @listeners unless @listeners.empty?
              @properties['Policies'] = @policies unless @policies.empty?
              @properties['SecurityGroups'] = @security_groups unless @security_groups.empty?
              @properties['Subnets'] = @subnets unless @subnets.empty?
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
