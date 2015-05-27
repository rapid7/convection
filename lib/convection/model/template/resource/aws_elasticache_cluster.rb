require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElastiCache::CacheCluster
        ##
        class ElastiCacheCluster < Resource

          property :auto_minor_version_upgrade, 'AutoMinorVersionUpgrade'
          property :cache_node_type, 'CacheNodeType'
          property :cache_security_group_names, 'CacheSecurityGroupNames'
          property :cache_parameter_group_name, 'CacheParameterGroupName'
          property :cluster_name, 'ClusterName'
          property :engine, 'Engine'
          property :engine_version, 'EngineVersion'
          property :num_cache_nodes, 'NumCacheNodes'

          def initialize(*args)
            super
            type 'AWS::ElastiCache::CacheCluster'
          end

        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def elasticache_cache_cluster(name, &block)
        r = Model::Template::Resource::ElastiCacheCluster.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
