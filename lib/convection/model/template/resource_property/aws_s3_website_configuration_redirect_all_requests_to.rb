require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-websiteconfiguration-redirectallrequeststo.html
        # Amazon S3 Website Configuration Redirect All Requests To}
        class S3WebsiteConfigurationRedirectAllRequestsTo < ResourceProperty
          property :host_name, 'HostName'
          property :protocol, 'Protocol'
        end
      end
    end
  end
end
