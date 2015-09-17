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
          property :network_interfaces, 'NetworkInterfaces', :type => :list

          # Append a network interface to network_interfaces
          def network_interface(&block)
            interface = ResourceProperty::EC2NetworkInterface.new(self)
            interface.instance_exec(&block) if block
            interface.device_index = network_interfaces.count.to_s
            network_interfaces << interface
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
