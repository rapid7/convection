require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distributionconfig-viewercertificate.html
        # CloudFront DistributionConfiguration ViewerCertificate Embedded Property Type}
        class CloudFrontViewerCertificate < ResourceProperty
          property :use_default, 'CloudFrontDefaultCertificate'
          property :iam_certificate, 'IamCertificateId'
          property :minimum_protocol_version, 'MinimumProtocolVersion'
          property :ssl_support_method, 'SslSupportMethod'
        end
      end
    end
  end
end
