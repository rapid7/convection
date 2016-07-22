require 'spec_helper'

class Convection::Model::Template
  describe Condition do
    let(:template) do
      Convection.template do
        description 'Condition Test Template'

        condition 'InProd' do
          fn_equals 'prod', 'prod'
        end

        resource 'SecurityGroup' do
          type 'AWS::EC2::SecurityGroup'
          condition 'InProd'
        end
      end
    end

    it 'can be referenced by resources' do
      resource = rendered_template
                 .fetch('Resources').fetch('SecurityGroup')
      expect(resource).to include('Condition' => 'InProd')
    end

    it 'can be referenced by resources' do
      resource = rendered_template
                 .fetch('Resources').fetch('SecurityGroup')
      expect(resource).to include('Condition' => 'InProd')
    end

    private

    def rendered_template
      JSON.parse(template.to_json)
    end
  end
end
