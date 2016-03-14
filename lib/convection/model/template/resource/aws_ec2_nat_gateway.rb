require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::NatGateway
        ##
        class EC2NatGateway < Resource
          type 'AWS::EC2::NatGateway'
          property :allocation_id, 'AllocationId'
          property :subnet, 'SubnetId'
        end
      end
    end
  end
end
