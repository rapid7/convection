require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::AutoScaling::AutoScalingGroup
        ##
        class AutoScalingGroup < Resource
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
          property :termination_policie, 'TerminationPolicies', :array
          property :vpc_zone_identifier, 'VPCZoneIdentifier', :array

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end

          def tag(key, value, propagate_at_launch: nil)
            tags[key] = { value: value }
            tags[key][:propagate_at_launch] = propagate_at_launch unless propagate_at_launch.nil?

            tags[key]
          end

          def tags
            @tags ||= {}
          end

          def update_policy(&block)
            policy = ResourceAttribute::UpdatePolicy.new(self)
            policy.instance_exec(&block) if block
          end

          private

          def render_tags(resource)
            rendered_tags = tags.map do |key, tag|
              rendered = { 'Key' => key, 'Value' => tag[:value] }
              rendered['PropagateAtLaunch'] = tag[:propagate_at_launch] if tag.key?(:propagate_at_launch)

              rendered
            end

            resource['Properties']['Tags'] = rendered_tags unless rendered_tags.empty?
          end
        end
      end
    end
  end
end
