require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::AutoScaling::LaunchConfiguration
        ##
        class LaunchConfiguration < Resource

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

          def initialize(*args)
            super
            type 'AWS::AutoScaling::LaunchConfiguration'
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def launch_configuration(name, &block)
        r = Model::Template::Resource::LaunchConfiguration.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
