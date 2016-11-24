require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html
        # EC2 Spot Fleet Request Config Data Launch Specification Network Interfaces Property Type}
        class EC2SpotFleetRequestConfigDataLaunchSpecificationsNetworkInterface < ResourceProperty
          property :associate_public_ip_address, 'AssociatePublicIpAddress'
          property :delete_on_termination, 'DeleteOnTermination'
          property :description, 'Description'
          property :device_index, 'DeviceIndex'
          property :groups, 'Groups', :type => :list
          property :network_interface_id, 'NetworkInterfaceId'
          property :private_ip_addresses, 'PrivateIpAddresses', :type => :list
          property :secondary_private_ip_address_count, 'SecondaryPrivateIpAddressCount'
          property :subnet, 'SubnetId'
        end
      end
    end
  end
end
