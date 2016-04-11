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
          property :termination_policie, 'TerminationPolicies', :array
          property :vpc_zone_identifier, 'VPCZoneIdentifier', :array

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
              @update_policy.render(resource) unless @update_policy.nil?
            end
          end

          def update_policy(&block)
            @update_policy = UpdatePolicy.new
            @update_policy.instance_exec(&block)
          end

          ##
          # UpdatePolicy for AWS::AutoScaling::AutoScalingGroup
          ##
          class UpdatePolicy
            def initialize
              @pause = 'PT5M'
              @min_in_service = 0
              @max_batch = 1
            end

            def pause_time(val)
              @pause = val
            end

            def min_instances_in_service(val)
              @min_in_service = val
            end

            def max_batch_size(val)
              @max_batch = val
            end

            def render(resource)
              resource.tap do |r|
                r['UpdatePolicy'] = {
                  'AutoScalingScheduledAction' => {
                    'IgnoreUnmodifiedGroupSizeProperties' => true
                  },
                  'AutoScalingRollingUpdate' => {
                    'MinInstancesInService' => @min_in_service,
                    'MaxBatchSize' => @max_batch,
                    'WaitOnResourceSignals' => false,
                    'PauseTime' => @pause
                  }
                }
              end
            end
          end
        end
      end
    end
  end
end
