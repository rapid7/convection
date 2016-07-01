require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-notificationconfig-lambdaconfig.html
        # Amazon S3 NotificationConfiguration LambdaConfiguration}
        class S3LambdaNotificationConfiguration < ResourceProperty
          property :event, 'Event'
          property :filter, 'Filter'
          property :function, 'Function'

          def filter(&block)
            filter = ResourceProperty::S3NotificationConfigurationFilter.new(self)
            filter.instance_exec(&block) if block
            properties['Filter'].set(filter)
          end
        end
      end
    end
  end
end
