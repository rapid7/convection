require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-origin.html
        # CloudFront Origin Embedded Property Type}
        class CloudFrontOrigin < ResourceProperty
          property :custom_origin, 'CustomOriginConfig'
          property :domain_name, 'DomainName'
          property :id, 'Id'
          property :origin_path, 'OriginPath'
          property :s3_origin, 'S3OriginConfig'

          def custom_origin(&block)
            origin = ResourceProperty::CloudFrontCustomOrigin.new(self)
            origin.instance_exec(&block) if block
            properties['CustomOriginConfig'].set(origin)
          end

          def s3_origin(&block)
            origin = ResourceProperty::CloudFrontS3Origin.new(self)
            origin.instance_exec(&block) if block
            properties['S3OriginConfig'].set(origin)
          end
        end
      end
    end
  end
end
