require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-logging.html
        # CloudFront Logging Embedded Property Type}
        class CloudFrontLogging < ResourceProperty
          property :bucket, 'Bucket'
          property :include_cookies, 'IncludeCookies'
          property :prefix, 'Prefix'
        end
      end
    end
  end
end
