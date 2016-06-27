require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-notificationconfiguration-config-filter-s3key-rules.html
        # Amazon S3 NotificationConfiguration Config Filter S3Key Rules}
        class S3NotificationConfigurationFilterS3KeyRule < ResourceProperty
          property :name, 'Name'
          property :value, 'Value'
        end
      end
    end
  end
end
