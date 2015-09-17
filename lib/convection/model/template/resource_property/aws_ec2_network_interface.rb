require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-network-iface-embedded.html
        # EC2 NetworkInterface Embedded Property Type}
        class EC2NetworkInterface < ResourceProperty
          property :associate_public_ip_address, 'AssociatePublicIpAddress'
          property :delete_on_termination, 'DeleteOnTermination'
          property :description, 'Description'
          property :device_index, 'DeviceIndex'
          property :group_set, 'GroupSet', :type => :list
          alias_method :security_group, :group_set
          property :private_ip_address, 'PrivateIpAddress'
          property :secondary_private_ip_address_count, 'SecondaryPrivateIpAddressCount'
          property :subnet, 'SubnetId'
        end
      end
    end
  end
end
