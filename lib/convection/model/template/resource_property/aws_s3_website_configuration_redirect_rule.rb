require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-websiteconfiguration-routingrules-redirectrule.html
        # Amazon S3 Website Configuration Routing Rule Redirect Rule}
        class S3WebsiteConfigurationRedirectRule < ResourceProperty
          property :host_name, 'HostName'
          property :http_redirect_code, 'HttpRedirectCode'
          property :protocol, 'Protocol'
          property :replace_key_prefix_with, 'ReplaceKeyPrefixWith'
          property :replace_key_with, 'ReplaceKeyWith'
        end
      end
    end
  end
end
