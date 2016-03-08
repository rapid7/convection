require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-mount-point.html
        # EC2 MountPoint Property Type}
        class EC2MountPoint < ResourceProperty
          property :device, 'Device'
          property :volume_id, 'VolumeId'
        end
      end
    end
  end
end
