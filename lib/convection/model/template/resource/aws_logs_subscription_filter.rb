require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Logs::SubscriptionFilter
        #
        # @example
        #   logs_subscription_filter 'TestSubscriptionFilter' do
        #     destination_arn 'arn:aws:logs:us-east-1:123456789012:destination:testDestination'
        #     filter_pattern  '{$.userIdentity.type = Root}'
        #     log_group_name  'CloudTrail'
        #     role_arn        'arn:aws:iam::123456789012:role/Root'
        #   end
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
