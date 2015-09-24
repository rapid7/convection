require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::SubnetRouteTableAssociation
        ##
        class EC2SubnetRouteTableAssociation < Resource
          type 'AWS::EC2::SubnetRouteTableAssociation'
          property :route_table, 'RouteTableId'
          property :subnet, 'SubnetId'
        end
      end
    end
  end
end
