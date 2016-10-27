require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-recordset-geolocation.html
        # Route53 GeoLocation Property Type}
        class Route53GeoLocation < ResourceProperty
          property :continent_code, 'ContinentCode'
          property :country_code, 'CountryCode'
          property :subdivision_code, 'SubdivisionCode'
        end
      end
    end
  end
end
