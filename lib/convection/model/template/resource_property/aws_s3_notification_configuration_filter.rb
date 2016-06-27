require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-notificationconfiguration-config-filter.html
        # Amazon S3 NotificationConfiguration Config Filter}
        class S3NotificationConfigurationFilter < ResourceProperty
          property :s3_key, 'S3Key'

          def s3_key(&block)
            s3_key = ResourceProperty::S3NotificationConfigurationFilterS3Key.new(self)
            s3_key.instance_exec(&block) if block
            properties['S3Key'].set(s3_key)
          end
        end
      end
    end
  end
end
