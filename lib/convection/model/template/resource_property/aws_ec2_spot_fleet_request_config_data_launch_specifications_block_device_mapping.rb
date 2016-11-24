require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings.html
        # EC2 Spot Fleet Request Config Data Launch Specifications Block Device Mapping Property Type}
        class EC2SpotFleetRequestConfigDataLaunchSpecificationsBlockDeviceMapping < ResourceProperty
          property :device_name, 'DeviceName'
          property :ebs, 'Ebs'
          property :no_device, 'NoDevice'
          property :virtual_name, 'VirtualName'

          def ebs(&block)
            config = ResourceProperty::EC2SpotFleetRequestConfigDataLaunchSpecificationsBlockDeviceMappingEbs.new(self)
            config.instance_exec(&block) if block
            properties['Ebs'].set(config)
          end
        end
      end
    end
  end
end
