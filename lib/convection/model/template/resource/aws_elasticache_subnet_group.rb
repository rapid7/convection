require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElastiCache::SubnetGroup
        ##
        class ElastiCacheSubnetGroup < Resource
          type 'AWS::ElastiCache::SubnetGroup', :elasticache_subnet_group
          property :description, 'Description'
          property :subnet_ids, 'SubnetIds'
        end
      end
    end
  end
end
