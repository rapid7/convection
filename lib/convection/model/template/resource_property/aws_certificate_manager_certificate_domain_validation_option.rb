require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-certificatemanager-certificate-domainvalidationoption.html
        # Certificate Manager Certificate DomainValidationOption Type}
        class CertificateManagerCertificateDomainValidationOption < ResourceProperty
          property :domain_name, 'DomainName'
          property :validation_domain, 'ValidationDomain'
        end
      end
    end
  end
end
