require 'spec_helper'

class Convection::Model::Template::Resource
  describe ElastiCacheSecurityGroup do
    let(:elasticache_template) do
      Convection.template do
        description 'Elasticache Test Template'

        elasticache_security_group 'MyRedisSecGroup' do
          description 'Redis cache security group'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('MyRedisSecGroup')
        .fetch('Properties')
    end

    it 'has a description' do
      expect(subject['Description']).to eq('Redis cache security group')
    end

    private

    def template_json
      JSON.parse(elasticache_template.to_json)
    end
  end
end
