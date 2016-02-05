require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distributionconfig-customerrorresponse.html
        # CloudFront DistributionConfig Restrictions GeoRestriction Embedded Property Type}
        class CloudFrontCustomErrorResponse < ResourceProperty
          property :min_ttl, 'ErrorCachingMinTTL'
          property :error_code, 'ErrorCode'
          property :response_code, 'ResponseCode'
          property :response_page_path, 'ResponsePagePath'
        end
      end
    end
  end
end
