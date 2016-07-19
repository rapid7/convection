require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::SQS::Queue
        #
        ##
        class SQSQueue < Resource
          # @example
          # sqs_queue 'NotifyQueue' do
          #   queue_name "my-notify-queue"
          #   visibility_timeout 3600
          # end
          include Model::Mixin::Taggable

          type 'AWS::SQS::Queue'
          property :delay_seconds, 'DelaySeconds'
          property :maximum_message_size, 'MaximumMessageSize'
          property :message_retention_period, 'MessageRetentionPeriod'
          property :queue_name, 'QueueName'
          property :receive_message_wait_time_seconds, 'ReceiveMessageWaitTimeSeconds'
          property :redrive_policy, 'RedrivePolicy'
          property :visibility_timeout, 'VisibilityTimeout'

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
