require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-efs-filesystem-filesystemtags.html
        # Amazon EFS File System Tag}
        class EFSFileSystemTag < ResourceProperty
          property :key, 'Key'
          property :value, 'Value'
        end
      end
    end
  end
end
