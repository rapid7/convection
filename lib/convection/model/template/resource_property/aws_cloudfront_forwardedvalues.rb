require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-forwardedvalues.html
        # CloudFront ForwardedValues Embedded Property Type}
        class CloudFrontForwardedValues < ResourceProperty
          property :cookies, 'Cookies'
          property :headers, 'Headers', :type => :list
          property :query_string, 'QueryString', :default => false
          property :query_string_cache_keys, 'QueryStringCacheKeys'

          def cookies(&block)
            values = ResourceProperty::CloudFrontForwardedValuesCookies.new(self)
            values.instance_exec(&block) if block
            properties['Cookies'].set(values)
          end
        end
      end
    end
  end
end
