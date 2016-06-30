require_relative '../../../../../spec_helper'

class Convection::Model::Template::Resource
  describe ElastiCacheCluster do
    let(:elasticache_template) do
      Convection.template do
        description 'Elasticache Test Template'

        ec2_security_group 'MyEC2SecGroup' do
          ingress_rule(:tcp, 22, 'my.ip.address')
        end

        elasticache_security_group 'MyRedisSecGroup' do
          description 'Redis cache security group'
        end

        elasticache_security_group_ingress 'MyRedisSecGroupIngress' do
          cache_security_group_name fn_ref('MyRedisSecGroup')
          ec2_security_group_name(fn_ref('MyEC2SecGroup'))
          ec2_security_group_owner_id('123456789012')
        end

        elasticache_parameter_group 'MyRedisParmGroup' do
          cache_parameter_group_family 'redis2.8'
          description 'Redis cache parameter group'
          parameter 'my_parm_key', 'my_parm_value'
        end

        elasticache_cache_cluster 'MyRedisCluster' do
          cluster_name 'demo'

          auto_minor_version_upgrade true
          cache_node_type 'cache.m3.medium'
          cache_parameter_group_name fn_ref('MyRedisParmGroup')
          cache_security_group_names [fn_ref('MyRedisSecGroup')]
          engine 'redis'
          engine_version '2.8.6'
          num_cache_nodes 1
        end
      end
    end

    context 'test elasticache instance' do
      let(:secgroups) do
        json = template_json.fetch('Resources').fetch('MyRedisCluster')
        json.fetch('Properties').fetch('CacheSecurityGroupNames')
      end

      it 'security group should be a array' do
        expect(secgroups).to be_a(Array)
      end

      it 'security group should be array with one element' do
        expect(secgroups.size).to eq(1)
      end

      it 'security group indexes consist of hashes' do
        expect(secgroups[0]).to be_a(Hash)
      end

      it 'security group index 0 has a size of one' do
        expect(secgroups[0].size).to eq(1)
      end

      it 'security group array index 0 hash key is Ref' do
        expect(secgroups[0].key?('Ref')).to eq(true)
      end

      it 'security group array index 0 hash value is MyRedisSecGroup' do
        expect(secgroups[0].value?('MyRedisSecGroup')).to eq(true)
      end

      it 'security group array index 1 is nil' do
        expect(secgroups[1]).to eq(nil)
      end
    end

    context 'test elasticache sec group ingress' do
      let(:params) do
        json = template_json.fetch('Resources').fetch('MyRedisParmGroup')
        json.fetch('Properties').fetch('Properties')
      end

      it 'is a hash' do
        expect(params).to be_a(Hash)
      end

      it 'is a hash with size 1' do
        expect(params.size).to eq(1)
      end

      it 'params has key my_parm_key' do
        expect(params.key?('my_parm_key')).to eq(true)
      end

      it 'params has value my_parm_value' do
        expect(params.value?('my_parm_value')).to eq(true)
      end
    end

    private

    def template_json
      JSON.parse(elasticache_template.to_json)
    end
  end
end
