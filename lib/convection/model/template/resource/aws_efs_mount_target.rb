require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-efs-mounttarget.html
        # Amazon EFS Mount Target}
        class EFSMountTarget < Resource
          type 'AWS::EFS::MountTarget'
          property :file_system_id, 'FileSystemId'
          property :ip_address, 'IpAddress'
          property :security_groups, 'SecurityGroups', :type => :list
          property :subnet_id, 'SubnetId'
        end
      end
    end
  end
end
