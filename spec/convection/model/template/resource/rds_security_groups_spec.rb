require 'spec_helper'

class Convection::Model::Template::Resource
  describe RDSDBInstance do
    let(:template) do
      Convection.template do
        description 'RDS Test Template'

        rds_security_group 'MyRDSSecGroup' do
          description 'Pulls in EC2 SGs'
          ec2_security_group 'MyEC2SecGroup', '123456789012'
          cidr_ip 'my_cidr_value'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('MyRDSSecGroup')
        .fetch('Properties')
    end

    it 'DBSecurityGroupIngress in a array' do
      expect(subject['DBSecurityGroupIngress']).to be_a(Array)
    end

    it 'ingress rules array contains 2 elements' do
      expect(subject['DBSecurityGroupIngress'].size).to eq(2)
    end

    it 'defines the cidr block correctly' do
      expect(subject['DBSecurityGroupIngress']).to include(hash_including('CIDRIP' => 'my_cidr_value'))
    end

    it 'defines EC2SecurityGroupName correctly' do
      expect(subject['DBSecurityGroupIngress']).to include(hash_including('EC2SecurityGroupName' => 'MyEC2SecGroup'))
    end

    it 'defines EC2SecurityGroupOwnerId correctly' do
      expect(subject['DBSecurityGroupIngress']).to include(hash_including('EC2SecurityGroupOwnerId' => '123456789012'))
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
