require 'spec_helper'

class Convection::Model::Template::Resource
  describe ElastiCacheSecurityGroupIngress do
    let(:template) do
      Convection.template do
        description 'Elasticache Test Template'

        elasticache_security_group_ingress 'MyRedisSecGroupIngress' do
          # NOTE: We do not have to actually be able to resolve these
          # function references for unit testing.
          cache_security_group_name     fn_ref('MyRedisSecGroup')
          ec2_security_group_name       fn_ref('MyEC2SecGroup')
          ec2_security_group_owner_id   '123456789012'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('MyRedisSecGroupIngress')
        .fetch('Properties')
    end

    it 'contains a reference to the specified cache security group name' do
      expect(subject['CacheSecurityGroupName']).to eq('Ref' => 'MyRedisSecGroup')
    end

    it 'contains a reference to the specified EC2 security group name' do
      expect(subject['EC2SecurityGroupName']).to eq('Ref' => 'MyEC2SecGroup')
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
