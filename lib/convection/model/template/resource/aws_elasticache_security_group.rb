require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElastiCache::SecurityGroup
        ##
        class ElastiCacheSecurityGroup < Resource

          property :description, 'Description'

          def initialize(*args)
            super
            type 'AWS::ElastiCache::SecurityGroup'
          end

        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def elasticache_security_group(name, &block)
        r = Model::Template::Resource::ElastiCacheSecurityGroup.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
