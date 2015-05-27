require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElastiCache::ParameterGroup
        ##
        class ElastiCacheParameterGroup < Resource

          property :cache_parameter_group_family, 'CacheParameterGroupFamily'
          property :description, 'Description'

          def initialize(*args)
            super
            type 'AWS::ElastiCache::ParameterGroup'
            @properties['Properties'] = {}
          end

          def parameter(key, value)
            @properties['Properties'][key] = value
            #@properties[key] = value
          end

        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def elasticache_parameter_group(name, &block)
        r = Model::Template::Resource::ElastiCacheParameterGroup.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
