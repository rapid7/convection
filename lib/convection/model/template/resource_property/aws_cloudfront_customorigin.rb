require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-customorigin.html
        # CloudFront DistributionConfig Origin S3Origin Embedded Property Type}
        class CloudFrontCustomOrigin < ResourceProperty
          property :http_port, 'HTTPPort', :default => 80
          property :https_port, 'HTTPSPort', :default => 443
          property :protocol_policy, 'OriginProtocolPolicy'
        end
      end
    end
  end
end
