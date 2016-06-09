require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::VPNConnection
        ##
        class EC2VPNConnection < Resource
          include Model::Mixin::Taggable

          type 'AWS::EC2::VPNConnection'
          property :conn_type, 'Type'
          property :static_routes_only, 'StaticRoutesOnly'
          property :customer_gateway_id, 'CustomerGatewayId'
          property :vpn_gateway_id, 'VpnGatewayId'

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
