require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElastiCache::SecurityGroupIngress
        ##
        class ElastiCacheSecurityGroupIngress < Resource
          type 'AWS::ElastiCache::SecurityGroupIngress', :elasticache_security_group_ingress
          property :cache_security_group_name, 'CacheSecurityGroupName'
          property :ec2_security_group_name, 'EC2SecurityGroupName'
          property :ec2_security_group_owner_id, 'EC2SecurityGroupOwnerId'
        end
      end
    end
  end
end
