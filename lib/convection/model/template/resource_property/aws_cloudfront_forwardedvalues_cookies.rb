require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-forwardedvalues-cookies.html
        # CloudFront ForwardedValues Cookies Embedded Property Type}
        class CloudFrontForwardedValuesCookies < ResourceProperty
          property :forward, 'Forward'
          property :whitelisted_names, 'WhitelistedNames', :type => :list
        end
      end
    end
  end
end
