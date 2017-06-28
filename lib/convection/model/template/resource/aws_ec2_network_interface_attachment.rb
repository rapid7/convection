require_relative '../resource'

module Convection
  module DSL
    module Template
      module Resource
        ##
        # Add DSL helpers to EC2NetworkACL
        ##
        module EC2NetworkInterfaceAttachment
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::NetworkACL
        ##
        class EC2NetworkInterfaceAttachment < Resource
          include DSL::Template::Resource::EC2NetworkInterfaceAttachment

          type 'AWS::EC2::NetworkInterfaceAttachment'
          property :delete_on_termination, 'DeleteOnTermination'
          property :device_index, 'DeviceIndex'
          property :instance_id, 'InstanceId'
          property :network_interface_id, 'NetworkInterfaceId'

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
