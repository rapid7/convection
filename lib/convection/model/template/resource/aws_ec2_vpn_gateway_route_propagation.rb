require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::VPNGatewayRoutePropagation
        ##
        class EC2VPNGatewayRoutePropagation < Resource
          type 'AWS::EC2::VPNGatewayRoutePropagation'
          property :route_table_ids, 'RouteTableIds'
          property :vpn_gateway_id, 'VpnGatewayId'
        end
      end
    end
  end
end
