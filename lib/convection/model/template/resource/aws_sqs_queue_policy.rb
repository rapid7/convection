require 'forwardable'
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::SQS::QueuePolicy
        #
        # @example
        # sqs_queue_policy 'QueuePolicy' do
        #   queue "my-queue"
        #   allow do
        #     principal '*'
        #     sqs_resource my_region, my_account, "my-queue"
        #     action 'sqs:SendMessage'
        #     condition :ArnEquals => { "AWS:SourceArn" => "arn:aws:sns:...." }
        #   end
        # end
        ##
        class SQSQueuePolicy < Resource
          extend Forwardable

          type 'AWS::SQS::QueuePolicy'
          property :queue, 'Queues', :type => :list
          attr_reader :document

          def_delegators :@document, :allow, :id, :version, :statement
          def_delegator :@document, :name, :policy_name

          def initialize(*args)
            super
            @document = Model::Mixin::Policy.new(:name => false, :template => @template)
          end

          def render
            super.tap do |r|
              document.render(r['Properties'])
            end
          end
        end
      end
    end
  end
end
