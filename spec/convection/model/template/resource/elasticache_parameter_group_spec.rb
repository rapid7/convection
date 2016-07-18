require 'spec_helper'

class Convection::Model::Template::Resource
  describe ElastiCacheParameterGroup do
    let(:elasticache_template) do
      Convection.template do
        description 'Elasticache Test Template'

        elasticache_parameter_group 'MyRedisParamGroup' do
          cache_parameter_group_family 'redis2.8'
          description 'Redis cache parameter group'
          parameter 'my_param_key', 'my_param_value'
          parameter 'my_other_key', 'my_other_value'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('MyRedisParamGroup')
        .fetch('Properties')
    end

    it 'has multiple parameters ("Properties")' do
      expect(subject['Properties']).to include(
        'my_param_key' => 'my_param_value',
        'my_other_key' => 'my_other_value'
      )
    end

    private

    def template_json
      JSON.parse(elasticache_template.to_json)
    end
  end
end
