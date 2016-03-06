require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Volume
        ##
        class EC2Volume < Resource
          include Model::Mixin::Taggable

          type 'AWS::EC2::Volume'
          property :auto_enable_io, 'AutoEnableIO'
          property :availability_zone, 'AvailabilityZone'
          property :encrypted, 'Encrypted'
          property :iops, 'Iops'
          property :kms_key, 'KmsKeyId'
          property :size, 'Size'
          property :snapshot, 'SnapshotId'
          property :volume_type, 'VolumeType'

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
