require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticsearch-domain-elasticsearchclusterconfig.html
        # Elasticsearch Cluster Config Property Type}
        class ElasticsearchDomainElasticsearchClusterConfig < ResourceProperty
          property :instance_count, 'InstanceCount'
          property :instance_type, 'InstanceType'
          property :dedicated_master_enabled, 'DedicatedMasterEnabled'
          property :dedicated_master_type, 'DedicatedMasterType'
          property :dedicated_master_count, 'DedicatedMasterCount'
          property :zone_awareness_enabled, 'ZoneAwarenessEnabled'
        end
      end
    end
  end
end
