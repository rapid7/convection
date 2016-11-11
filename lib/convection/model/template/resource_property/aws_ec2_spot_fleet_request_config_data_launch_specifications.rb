require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html
        # EC2 Spot Fleet Request Config Data Launch Specification Property Type}
        class EC2SpotFleetRequestConfigDataLaunchSpecifications < ResourceProperty
          property :block_device_mappings, 'BlockDeviceMappings', :type => :array
          property :ebs_optimized, 'EbsOptimized'
          property :iam_instance_profile, 'IamInstanceProfile'
          property :image_id, 'ImageId'
          property :instance_type, 'InstanceType'
          property :kernel_id, 'KernelId'
	  property :key_name, 'KeyName'
          property :monitoring, 'Monitoring'
          property :network_interfaces, 'NetworkInterfaces', :type => :array
          property :placement, 'Placement'
          property :ramdisk_id, 'RamdiskId'
          property :security_groups, 'SecurityGroups', :type => :array
          property :spot_price, 'SpotPrice'
          property :subnet_id, 'SubnetId'
          property :user_data, 'UserData'
          property :weighted_capacity, 'WeightedCapacity'

          def block_device_mapping(&block)
            block_device_mapping = ResourceProperty::EC2SpotFleetRequestConfigDataLaunchSpecificationsBlockDeviceMapping.new(self)
            block_device_mapping.instance_exec(&block) if block
            block_device_mappings << block_device_mapping 
          end

          def iam_instance_profile(&block)
            iam = ResourceProperty::EC2SpotFleetRequestConfigDataLaunchSpecificationsIamInstanceProfile.new(self)
            iam.instance_exec(&block) if block
            properties['IamInstanceProfile'].set(iam)
          end
          
          def network_interfaces(&block)
            network_interface = ResourceProperty::EC2SpotFleetRequestConfigDataLaunchSpecificationsNetworkInterface.new(self)
            network_interface.instance_exec(&block) if block
            network_interfaces << network_interface
          end

          def security_group (&block)
            sec_group = ResourceProperty::EC2SpotFleetRequestConfigDataLaunchSpecificationsSecurityGroups.new(self)
            sec_group.instance_exec(&block) if block
            security_groups << sec_group
          end
        end
      end
    end
  end
end
