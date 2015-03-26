require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::AutoScaling::AutoScalingGroup
        ##
        class AutoScalingGroup < Resource
          include Model::Mixin::Taggable

          property :availability_zone, 'AvailabilityZones', :array
          property :cooldown, 'Cooldown'
          property :desired_capacity, 'DesiredCapacity'
          property :health_check_grace_period, 'HealthCheckGracePeriod'
          property :health_check_type, 'HealthCheckType'
          property :instance_id, 'InstanceId'
          property :launch_configuration_name, 'LaunchConfigurationName'
          property :load_balancer_name, 'LoadBalancerNames', :array
          property :max_size, 'MaxSize'
          property :metrics_collection, 'MetricsCollection', :array
          property :min_size, 'MinSize'
          property :notification_configuration, 'NotificationConfiguration'
          property :placement_group, 'PlacementGroup'
          property :termination_policie, 'TerminationPolicies', :array
          property :vpc_zone_identifier, 'VPCZoneIdentifier', :array

          def initialize(*args)
            super
            type AWS::AutoScaling::AutoScalingGroup
          end

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
      def autoscaling_group(name, &block)
        r = Model::Template::Resource::AutoScalingGroup.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
