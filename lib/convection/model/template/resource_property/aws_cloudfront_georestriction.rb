require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distributionconfig-restrictions-georestriction.html
        # CloudFront DistributionConfig Restrictions GeoRestriction Embedded Property Type}
        class CloudFrontGeoRestriction < ResourceProperty
          property :locations, 'Locations', :type => :array
          property :type, 'RestrictionType'
        end
      end
    end
  end
end
