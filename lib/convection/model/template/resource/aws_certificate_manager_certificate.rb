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

          # Append a domain_validation_option to domain_validation_options
          def domain_validation_option(&block)
            option = ResourceProperty::CertificateManagerCertificateDomainValidationOption.new(self)
            option.instance_exec(&block) if block
            domain_validation_options << option
          end

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
