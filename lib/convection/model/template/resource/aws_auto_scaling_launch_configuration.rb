require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::AutoScaling::LaunchConfiguration
        ##
        class LaunchConfiguration < Resource
          type 'AWS::AutoScaling::LaunchConfiguration'
          property :associate_public_ip_address, 'AssociatePublicIpAddress'
          property :block_device_mappings, 'BlockDeviceMappings', :array
          property :ebs_optimized, 'EbsOptimized'
          property :iam_instanceProfile, 'IamInstanceProfile'
          property :image_id, 'ImageId'
          property :instance_id, 'InstanceId'
          property :instance_monitoring, 'InstanceMonitoring'
          property :instance_type, 'InstanceType'
          property :kernel_id, 'KernelId'
          property :key_name, 'KeyName'
          property :ram_diskId, 'RamDiskId'
          property :security_group, 'SecurityGroups', :array
          property :spot_price, 'SpotPrice'
          property :user_data, 'UserData'

          def block_device_mapping(&block)
            dev_map = ResourceProperty::EC2BlockDeviceMapping.new(self)
            dev_map.instance_exec(&block) if block
            block_device_mappings << dev_map
          end
        end
      end
    end
  end
end
