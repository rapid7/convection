require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticsearch-domain-snapshotoptions.html
        # Snapshot Options Property Type}
        class ElasticsearchDomainSnapshotOptions < ResourceProperty
          property :automated_snapshot_start_hour, 'AutomatedSnapshotStartHour'
        end
      end
    end
  end
end
