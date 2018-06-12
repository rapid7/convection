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
        #   end
        class SNSSubscription < Resource
          type 'AWS::SNS::Subscription'
          property :endpoint, 'Endpoint'
          property :protocol, 'Protocol'
          property :topic_arn, 'TopicArn'
        end
      end
    end
  end
end
