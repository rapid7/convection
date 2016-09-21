require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-replicationconfiguration-rules.html}
        # Amazon S3 Replication Configuration Rules
        class S3ReplicationConfigurationRule < ResourceProperty
          property :destination, 'Destination'
          property :id, 'Id'
          property :prefix, 'Prefix'
          property :status, 'Status'

          def destination(&block)
            destination_bucket = ResourceProperty::S3ReplicationConfigurationRuleDestination.new(self)
            destination_bucket.instance_exec(&block) if block
            properties['Destination'].set(destination_bucket)
          end
        end
      end
    end
  end
end
