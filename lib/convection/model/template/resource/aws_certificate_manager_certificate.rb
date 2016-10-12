require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::CertificateManager::Certificate
        ##
        class CertificateManagerCertificate < Resource
          include Model::Mixin::Taggable

          type 'AWS::CertificateManager::Certificate', :certificate_manager_certificate
          property :domain_name, 'DomainName'
          property :domain_validation_options, 'DomainValidationOptions', :type => :list
          property :subject_alternative_names, 'SubjectAlternativeNames', :type => :list
          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
