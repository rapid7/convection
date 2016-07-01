require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distributionconfig-restrictions.html
        # CloudFront DistributionConfiguration Restrictions Embedded Property Type}
        class CloudFrontRestrictions < ResourceProperty
          property :geo, 'GeoRestriction'

          def geo(&block)
            restriction = ResourceProperty::CloudFrontGeoRestriction.new(self)
            restriction.instance_exec(&block) if block
            properties['GeoRestriction'].set(restriction)
          end
        end
      end
    end
  end
end
