require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticache-replicationgroup-nodegroupconfiguration.html
        # Amazon ElastiCache ReplicationGroup NodeGroupConfiguration}
        class ElasticacheReplicationGroupNodeGroupConfiguration < ResourceProperty
          property :primary_availability_zone, 'PrimaryAvailabilityZone'
          property :replica_availability_zones, 'ReplicaAvailabilityZones', :type => :list
          property :replica_count, 'ReplicaCount'
          property :slots, 'Slots'
        end
      end
    end
  end
end