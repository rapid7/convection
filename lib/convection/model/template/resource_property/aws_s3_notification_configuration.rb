require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-notificationconfig.html
        # Amazon S3 Notification Configuration}
        class S3NotificationConfiguration < ResourceProperty
          property :lambda_configurations, 'LambdaConfigurations', :type => :list
          property :queue_configurations, 'QueueConfigurations', :type => :list
          property :topic_configurations, 'TopicConfigurations', :type => :list

          def lambda_configuration(&block)
            lambda_configuration = ResourceProperty::S3LambdaNotificationConfiguration.new(self)
            lambda_configuration.instance_exec(&block) if block
            lambda_configurations << lambda_configuration
          end

          def queue_configuration(&block)
            queue_configuration = ResourceProperty::S3QueueNotificationConfiguration.new(self)
            queue_configuration.instance_exec(&block) if block
            queue_configurations << queue_configuration
          end

          def topic_configuration(&block)
            topic_configuration = ResourceProperty::S3TopicNotificationConfiguration.new(self)
            topic_configuration.instance_exec(&block) if block
            topic_configurations << topic_configuration
          end
        end
      end
    end
  end
end
