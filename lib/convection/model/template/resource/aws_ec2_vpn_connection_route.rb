require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::VPNConnectionRoute
        ##
        class EC2VPNConnectionRoute < Resource
          type 'AWS::EC2::VPNConnectionRoute'
          property :destination, 'DestinationCidrBlock'
          property :vpn_connection_id, 'VpnConnectionId'
        end
      end
    end
  end
end
