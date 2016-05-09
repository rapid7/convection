require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::VPCPeeringConnection
        ##
        class EC2VPCPeeringConnection < Resource
          type 'AWS::EC2::VPCPeeringConnection'
          property :vpc, 'VpcId'
          property :peer_vpc, 'PeerVpcId'
        end
      end
    end
  end
end
