require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::SNS::Topic
        ##
        class SNSTopic < Resource
          type 'AWS::SNS::Topic'
          property :display_name, 'DisplayName'
          property :subscription, 'Subscription', :array
          property :topic_name, 'TopicName'
        end
      end
    end
  end
end
