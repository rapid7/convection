require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-s3origin.html
        # CloudFront DistributionConfig Origin S3Origin Embedded Property Type}
        class CloudFrontS3Origin < ResourceProperty
          property :access_identity, 'OriginAccessIdentity'
        end
      end
    end
  end
end
