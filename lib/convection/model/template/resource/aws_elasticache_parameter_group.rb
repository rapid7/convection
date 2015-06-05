require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElastiCache::ParameterGroup
        ##
        class ElastiCacheParameterGroup < Resource

          type 'AWS::ElastiCache::ParameterGroup'
          property :cache_parameter_group_family, 'CacheParameterGroupFamily'
          property :description, 'Description'

          def initialize(*args)
            super
            @properties['Properties'] = {}
          end

          def parameter(key, value)
            @properties['Properties'][key] = value
          end

        end
      end
    end
  end
end
