require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Instance
        ##
        class EC2Instance < Resource
          include Model::Mixin::Taggable

          type 'AWS::EC2::Instance'
          property :availability_zone, 'AvailabilityZone'
          property :image_id, 'ImageId'
          property :instance_type, 'InstanceType'
          property :instance_profile, 'IamInstanceProfile'
          property :key_name, 'KeyName'
          property :subnet, 'SubnetId'
          property :user_data, 'UserData'
          property :security_group, 'SecurityGroupIds', :type => :list
          property :src_dst_checks, 'SourceDestCheck'
          property :disable_api_termination, 'DisableApiTermination'
          property :network_interfaces, 'NetworkInterfaces', :type => :list
          property :block_devices, 'BlockDeviceMappings', :type => :list
          property :volumes, 'Volumes', :type => :list
          property :ebs_optimized, 'EbsOptimized'
          property :monitoring, 'Monitoring'

          # Append a network interface to network_interfaces
          def network_interface(&block)
            interface = ResourceProperty::EC2NetworkInterface.new(self)
            interface.instance_exec(&block) if block
            interface.device_index = network_interfaces.count.to_s
            network_interfaces << interface
          end

          # Append a block device mapping
          def block_device(&block)
            block_device = ResourceProperty::EC2BlockDeviceMapping.new(self)
            block_device.instance_exec(&block) if block
            block_devices << block_device
          end

          # Append a volume to volumes
          def volume(&block)
            volume = ResourceProperty::EC2MountPoint.new(self)
            volume.instance_exec(&block) if block
            volumes << volume
          end

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
