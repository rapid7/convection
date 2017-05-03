require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-apitgateway-restapi-bodys3location.html
        # API Gateway RestApi S3Location Property Type}
        class ApiGatewayRestApiS3Location < ResourceProperty
          property :bucket, 'Bucket'
          property :e_tag, 'ETag'
          property :key, 'Key'
          property :version, 'Version'
        end
      end
    end
  end
end
