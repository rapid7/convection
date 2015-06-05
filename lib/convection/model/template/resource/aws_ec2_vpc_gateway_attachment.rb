require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::VPCGatewayAttachment
        ##
        class EC2VPCGatewayAttachment < Resource
          type 'AWS::EC2::VPCGatewayAttachment'
          property :vpc, 'VpcId'
          property :internet_gateway, 'InternetGatewayId'
          property :vpn_gateway, 'VpnGatewayId'
        end
      end
    end
  end
end
