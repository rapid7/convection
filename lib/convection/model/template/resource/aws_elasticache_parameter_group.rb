require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElastiCache::ParameterGroup
        ##
        class ElastiCacheParameterGroup < Resource
          type 'AWS::ElastiCache::ParameterGroup', :elasticache_parameter_group
          property :cache_parameter_group_family, 'CacheParameterGroupFamily'
          property :description, 'Description'
          property :parameter, 'Properties', :type => :hash
        end
      end
    end
  end
end
