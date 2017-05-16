require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::AutoScaling::ScheduledAction
        ##
        class ScheduledAction < Resource
          type 'AWS::AutoScaling::ScheduledAction'
          property :auto_scaling_group_name, 'AutoScalingGroupName'
          property :desired_capacity, 'DesiredCapacity'
          property :end_time, 'EndTime'
          property :max_size, 'MaxSize'
          property :min_size, 'MinSize'
          property :recurrence, 'Recurrence'
          property :start_time, 'StartTime'
        end
      end
    end
  end
end
