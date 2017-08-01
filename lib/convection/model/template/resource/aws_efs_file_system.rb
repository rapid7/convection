require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-efs-filesystem.html
        # Amazon EFS File System}
        class EFSFileSystem < Resource
          type 'AWS::EFS::FileSystem'
          property :performance_mode, 'PerformanceMode'

          def file_system_tags(value = nil)
            return @file_system_tags if value.nil?
            @file_system_tags = Convection::Model::Tags[value]
          end

          def file_system_tag(key, value)
            @file_system_tags ||= Convection::Model::Tags.new
            @file_system_tags[key] = value
          end

          def render(*args)
            super.tap do |resource|
              unless file_system_tags.nil? || file_system_tags.empty?
                resource['Properties']['FileSystemTags'] = file_system_tags.render
              end
            end
          end
        end
      end
    end
  end
end
