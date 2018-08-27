require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        # @example
        #   sns_subscription 'MySubscription' do
        #     endpoint 'failures@example.com'
        #     protocol 'email'
        #     topic_arn 'arn:aws:sns:us-west-2:123456789012:example-topic'
        #     filter_policy 'Type' => 'Notification', 'MessageId' => 'e3c4e17a-819b-5d95-a0e8-b306c25afda0', 'MessageAttributes' => [{' AttributeName' => 'Name', 'KeyType' => 'HASH' }],
        #   end
        class SNSSubscription < Resource
          type 'AWS::SNS::Subscription'
          property :endpoint, 'Endpoint'
          property :protocol, 'Protocol'
          property :topic_arn, 'TopicArn'
          property :filter_policy, 'FilterPolicy'
        end
      end
    end
  end
end
