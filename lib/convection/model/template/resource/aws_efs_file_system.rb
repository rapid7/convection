require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-efs-filesystem.html
        # Amazon EFS File System}
        class EFSFileSystem < Resource
          type 'AWS::EFS::FileSystem'
          property :file_system_tags, 'FileSystemTags', :type => :list
          property :performance_mode, 'PerformanceMode'

          def file_system_tag(&block)
            tag = ResourceProperty::EFSFileSystemTag.new(self)
            tag.instance_exec(&block) if block
            file_system_tags << tag
          end
        end
      end
    end
  end
end
