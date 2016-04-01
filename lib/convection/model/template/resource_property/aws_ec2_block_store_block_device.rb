require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-blockdev-template.html
        # EC2 Block Store Block Device Property Type}
        class EC2BlockStoreBlockDevice < ResourceProperty
          property :delete_on_termination, 'DeleteOnTermination'
          property :encrypted, 'Encrypted'
          property :iops, 'Iops'
          property :snapshot, 'SnapshotId'
          property :volume_size, 'VolumeSize'
          alias size volume_size
          property :volume_type, 'VolumeType'
          alias type volume_type
        end
      end
    end
  end
end
