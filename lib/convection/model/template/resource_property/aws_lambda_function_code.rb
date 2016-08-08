require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-function-code.html}
        class LambdaFunctionCode < ResourceProperty
          property :s3_bucket, 'S3Bucket'
          property :s3_key, 'S3Key'
          property :s3_object_version, 'S3ObjectVersion'
          property :zip_file, 'ZipFile'
        end
      end
    end
  end
end
