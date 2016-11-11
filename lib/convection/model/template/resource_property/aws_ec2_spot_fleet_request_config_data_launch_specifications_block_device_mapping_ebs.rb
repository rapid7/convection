require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs.html
        # EC2 Spot Fleet Request Config Data Launch Specifications Block Device Mapping Ebs Property Type}
        class EC2SpotFleetRequestConfigDataLaunchSpecificationsBlockDeviceMappingEbs < ResourceProperty
          property :delete_on_termination, 'DeleteOnTermination'
          property :encrypted, 'Encrypted'
          property :iops, 'Iops'
          property :snapshot_id, 'SnapshotId'
          property :volume_size, 'VolumeSize'
          property :volume_type, 'VolumeType'

        end
      end
    end
  end
end
