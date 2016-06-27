require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-notificationconfiguration-config-filter-s3key.html
        # Amazon S3 NotificationConfiguration Config Filter S3Key}
        class S3NotificationConfigurationFilterS3Key < ResourceProperty
          property :rules, 'Rules', :type => :list

          def rule(&block)
            rule = ResourceProperty::S3NotificationConfigurationFilterS3KeyRule.new(self)
            rule.instance_exec(&block) if block
            rules << rule
          end
        end
      end
    end
  end
end
