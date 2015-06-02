require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElastiCache::SecurityGroupIngress
        ##
        class ElastiCacheSecurityGroupIngress < Resource

          property :cache_security_group_name, 'CacheSecurityGroupName'
          property :ec2_security_group_name, 'EC2SecurityGroupName'
          property :ec2_security_group_owner_id, 'EC2SecurityGroupOwnerId'

          def initialize(*args)
            super
            type 'AWS::ElastiCache::SecurityGroupIngress'
          end

        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def elasticache_security_group_ingress(name, &block)
        r = Model::Template::Resource::ElastiCacheSecurityGroupIngress.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
