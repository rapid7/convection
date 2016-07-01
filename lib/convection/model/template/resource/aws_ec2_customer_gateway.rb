require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::CustomerGateway
        ##
        class EC2CustomerGateway < Resource
          include Model::Mixin::Taggable

          type 'AWS::EC2::CustomerGateway'
          property :connection_type, 'Type'
          property :bgp_asn, 'BgpAsn'
          property :ip_address, 'IpAddress'

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
