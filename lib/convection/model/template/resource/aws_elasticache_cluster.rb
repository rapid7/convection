require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElastiCache::CacheCluster
        ##
        class ElastiCacheCluster < Resource
          type 'AWS::ElastiCache::CacheCluster', :elasticache_cache_cluster
          property :auto_minor_version_upgrade, 'AutoMinorVersionUpgrade'
          property :cache_node_type, 'CacheNodeType'
          property :cache_security_group_names, 'CacheSecurityGroupNames'
          property :cache_parameter_group_name, 'CacheParameterGroupName'
          property :cache_subnet_group_name, 'CacheSubnetGroupName'
          property :cluster_name, 'ClusterName'
          property :engine, 'Engine'
          property :engine_version, 'EngineVersion'
          property :num_cache_nodes, 'NumCacheNodes'
          property :vpc_security_group_ids, 'VpcSecurityGroupIds'
        end
      end
    end
  end
end
