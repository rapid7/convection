require 'spec_helper'

class Convection::Model::Template::Resource
  describe ElastiCacheCluster do
    let(:template) do
      Convection.template do
        description 'Elasticache Test Template'

        elasticache_cache_cluster 'MyRedisCluster' do
          cluster_name 'RedisCluster007'

          auto_minor_version_upgrade true
          cache_node_type 'cache.m3.medium'

          # NOTE: We do not have to actually be able to resolve these
          # function references for unit testing.
          cache_parameter_group_name fn_ref('MyRedisParmGroup')
          cache_security_group_names [fn_ref('MyRedisSecGroup')]

          engine 'redis'
          engine_version '2.8.6'
          num_cache_nodes 1
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('MyRedisCluster')
        .fetch('Properties')
    end

    it 'references the specified security group names' do
      expect(subject['CacheSecurityGroupNames']).to include('Ref' => 'MyRedisSecGroup')
    end

    it 'specifies the cluster name RedisCluster007' do
      expect(subject['ClusterName']).to eq('RedisCluster007')
    end

    it 'specifies the engine redis' do
      expect(subject['Engine']).to eq('redis')
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
