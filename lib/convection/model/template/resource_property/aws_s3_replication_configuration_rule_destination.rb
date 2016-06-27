require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-replicationconfiguration-rules-destination.html
        # Amazon S3 Replication Configuration Rule Destination}
        class S3ReplicationConfigurationRuleDestination < ResourceProperty
          property :bucket, 'Bucket'
          property :storage_class, 'StorageClass'
        end
      end
    end
  end
end
