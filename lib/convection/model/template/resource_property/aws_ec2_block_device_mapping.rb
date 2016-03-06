require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-blockdev-mapping.html
        # EC2 Block Device Mapping Property Type}
        class EC2BlockDeviceMapping < ResourceProperty
          property :device_name, 'DeviceName'
          alias device device_name
          property :ebs, 'Ebs'
          property :no_device, 'NoDevice'
          property :virtual_name, 'VirtualName'

          def ebs(&block)
            ebs = ResourceProperty::EC2BlockStoreBlockDevice.new(self)
            ebs.instance_exec(&block) if block
            properties['Ebs'].set(config)
          end
        end
      end
    end
  end
end
