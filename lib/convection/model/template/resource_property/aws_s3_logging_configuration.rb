require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-loggingconfig.html
        # Amazon S3 Logging Configuration}
        class S3LoggingConfiguration < ResourceProperty
          property :destination_bucket_name, 'DestinationBucketName'
          property :log_file_prefix, 'LogFilePrefix'
        end
      end
    end
  end
end
