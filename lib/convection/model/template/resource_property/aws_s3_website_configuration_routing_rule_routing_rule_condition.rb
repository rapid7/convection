require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-websiteconfiguration-routingrules-routingrulecondition.html
        # Amazon S3 Website Configuration Routing Rule Routing Rule Condition}
        class S3WebsiteConfigurationRoutingRule < ResourceProperty
          property :http_error_code_returned_equals, 'HttpErrorCodeReturnedEquals'
          property :key_prefix_equals, 'KeyPrefixEquals'
        end
      end
    end
  end
end
