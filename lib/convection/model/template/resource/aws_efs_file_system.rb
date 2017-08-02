require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-efs-filesystem.html
        # Amazon EFS File System}
        class EFSFileSystem < Resource
          include Model::Mixin::Taggable
          alias file_system_tag tag

          type 'AWS::EFS::FileSystem'
          property :performance_mode, 'PerformanceMode'

          def render(*args)
            super.tap do |resource|
              resource['Properties']['FileSystemTags'] = tags.render unless tags.empty?
            end
          end
        end
      end
    end
  end
end
