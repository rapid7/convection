require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::SNS::Topic
        #
        # @example
        # sns_topic 'MyTopic' do
        #   display_name 'my topic'
        #   topic_name "example-topic"
        #   subscription [{"Protocol" => "sqs", "Endpoint" => "arn:aws:sqs:....}]
        # end
        #
        ##
        class SNSTopic < Resource
          type 'AWS::SNS::Topic'
          property :display_name, 'DisplayName'
          property :subscription, 'Subscription', :type => :list
          property :topic_name, 'TopicName'
        end
      end
    end
  end
end
