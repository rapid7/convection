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

          type 'AWS::AutoScaling::AutoScalingGroup'
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
          property :termination_policy, 'TerminationPolicies', :array
          property :vpc_zone_identifier, 'VPCZoneIdentifier', :array

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end

          def update_policy(&block)
            policy = ResourceAttribute::UpdatePolicy.new(self)
            policy.instance_exec(&block) if block
          end
        end
      end
    end
  end
end
