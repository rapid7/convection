require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::SubnetRouteTableAssociation
        ##
        class EC2SubnetNetworkACLAssociation < Resource
          type 'AWS::EC2::SubnetNetworkAclAssociation'
          property :acl, 'NetworkAclId'
          property :subnet, 'SubnetId'
        end
      end
    end
  end
end
