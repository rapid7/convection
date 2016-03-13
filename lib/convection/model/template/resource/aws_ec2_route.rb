require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Route
        ##
        class EC2Route < Resource
          type 'AWS::EC2::Route'
          property :route_table_id, 'RouteTableId'
          property :destination, 'DestinationCidrBlock'
          property :gateway, 'GatewayId'
          property :nat_gateway, 'NatGatewayId'
          property :instance, 'InstanceId'
          property :interface, 'NetworkInterfaceId'
          property :peer, 'VpcPeeringConnectionId'
        end
      end
    end
  end
end
