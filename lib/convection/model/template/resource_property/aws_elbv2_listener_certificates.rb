require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticloadbalancingv2-listener-certificates.html
        # Elastic Load Balancing Listener Certificates}
        class ELBV2ListenerCertificates < ResourceProperty
          property :certificate_arn, 'CertificateArn'
        end
      end
    end
  end
end
