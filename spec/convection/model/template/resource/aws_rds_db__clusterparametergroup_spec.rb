require 'spec_helper'

class Convection::Model::Template::Resource
  describe RDSDBClusterParameterGroup do
    let(:template) do
      Convection.template do
        rds_cluster_parameter_group 'DemoRDSClusterParameterGroup' do
          description 'A sample parameter group'
          family 'aurora5.6'
          parameter 'time_zone', 'US/Eastern'
          tag 'Name', 'Test'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('DemoRDSClusterParameterGroup')
        .fetch('Properties')
    end

    it 'sets the Description' do
      expect(subject['Description']).to eq('A sample parameter group')
    end

    it 'has a Family' do
      expect(subject['Family']).to eq('aurora5.6')
    end

    it 'has Parameters' do
      expect(subject['Parameters']).to eq({'time_zone'=>'US/Eastern'})
    end

    it 'sets tags' do
      expect(subject['Tags']).to include(hash_including('Key' => 'Name', 'Value' => 'Test'))
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
