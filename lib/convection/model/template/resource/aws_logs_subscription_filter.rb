require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Logs::SubscriptionFilter
        ##
        class SubscriptionFilter < Resource
          type 'AWS::Logs::SubscriptionFilter'
          property :destination_arn, 'DestinationArn'
          property :filter_pattern, 'FilterPattern'
          property :log_group_name, 'LogGroupName'
          property :role_arn, 'RoleArn'
        end
      end
    end
  end
end
