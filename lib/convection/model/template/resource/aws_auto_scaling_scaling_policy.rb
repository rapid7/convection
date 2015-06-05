require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::AutoScaling::ScalingPolicy
        ##
        class ScalingPolicy < Resource
          type 'AWS::AutoScaling::ScalingPolicy'
          property :adjustment_type, 'AdjustmentType'
          property :auto_scaling_group_name, 'AutoScalingGroupName'
          property :cooldown, 'Cooldown'
          property :scaling_adjustment, 'ScalingAdjustment'
        end
      end
    end
  end
end
