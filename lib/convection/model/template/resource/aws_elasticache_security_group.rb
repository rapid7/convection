require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElastiCache::SecurityGroup
        ##
        class ElastiCacheSecurityGroup < Resource
          type 'AWS::ElastiCache::SecurityGroup', :elasticache_security_group
          property :description, 'Description'
        end
      end
    end
  end
end
