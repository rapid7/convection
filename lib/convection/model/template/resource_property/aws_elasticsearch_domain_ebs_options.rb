require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticsearch-domain-ebsoptions.html
        # EBS Options Property Type}
        class ElasticsearchDomainEBSOptions < ResourceProperty
          property :ebs_enabled, 'EBSEnabled'
          property :volume_type, 'VolumeType'
          property :volume_size, 'VolumeSize'
          property :iops, 'Iops'
        end
      end
    end
  end
end
