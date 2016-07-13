require 'spec_helper'

class Convection::Model::Template::Resource
  describe EC2SecurityGroup do
    let(:template) do
      Convection.template do
        description 'Elasticache Test Template'

        ec2_security_group 'MyEC2SecGroup' do
          description 'EC2 security group'

          vpc 'vpc-deadb33f'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('MyEC2SecGroup')
        .fetch('Properties')
    end

    # TODO: Write more meaningful specs for EC2SecurityGroup around things like ingress/egress or the taggable mixin
    it 'has a description' do
      expect(subject['GroupDescription']).to eq('EC2 security group')
    end

    it 'has a description' do
      expect(subject['VpcId']).to eq('vpc-deadb33f')
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
