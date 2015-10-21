require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-forwardedvalues.html
        # CloudFront ForwardedValues Embedded Property Type}
        class CloudFrontForwardedValues < ResourceProperty
          property :headers, 'Headers', :type => :list
          property :query_string, 'QueryString', :default => false
        end
      end
    end
  end
end
