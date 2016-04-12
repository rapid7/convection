require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-function-code.html}
        class LambdaFunctionCode < ResourceProperty
          property :s3_bucket, 'S3Bucket'
          property :s3_key, 'S3Key'
        end
      end
    end
  end
end
