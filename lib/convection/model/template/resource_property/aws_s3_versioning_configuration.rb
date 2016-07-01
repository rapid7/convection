require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-versioningconfig.html
        # Amazon S3 Versioning Configuration}
        class S3VersioningConfiguration < ResourceProperty
          property :status, 'Status'
        end
      end
    end
  end
end
