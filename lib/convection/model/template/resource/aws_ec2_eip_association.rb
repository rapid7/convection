require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::EIPAssociation
        ##
        class EIPAssociation < Resource
          type 'AWS::EC2::EIPAssociation'
          property :allocation_id, 'AllocationId'
          property :eip, 'EIP'
          property :instance_id, 'InstanceId'
          property :network_interface_id, 'NetworkInterfaceId'
          property :private_ip_address, 'PrivateIpAddress'
        end
      end
    end
  end
end
