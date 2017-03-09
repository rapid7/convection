require_relative '../resource_attribute'

module Convection
  module Model
    class Template
      class ResourceAttribute
        # Represents {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-updatepolicy.html}
        class UpdatePolicy < ResourceAttribute
          @pause = 'PT5M'
          @min_in_service = 0
          @max_batch = 1
          @wait_on_res = false

          def pause_time(val)
            @pause = val
          end

          def min_instances_in_service(val)
            @min_in_service = val
          end

          def max_batch_size(val)
            @max_batch = val
          end

          def wait_on_resource_signals(val)
            @wait_on_res = val
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
                  'WaitOnResourceSignals' => @wait_on_res,
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
