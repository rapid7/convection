require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::SQS::QueuePolicy
        ##
        class SQSQueuePolicy < Resource
          type 'AWS::SQS::QueuePolicy'
          property :queue, 'Queues', :type => :list
          property :policy_document, 'PolicyDocument'
        end
      end
    end
  end
end
