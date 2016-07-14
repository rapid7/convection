require 'spec_helper'

class Convection::Model::Template::Resource
  describe EC2Subnet do
    let(:template) do
      Convection.template do
        description 'Ec2 Subnet'

        ec2_subnet 'PublicSubnet' do
          network '10.10.11.0/24'
          availability_zone 'us-east-1a'
          tag 'Name', 'subnet'
          vpc fn_ref('DemoVPC')
          public_ips true
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('PublicSubnet')
        .fetch('Properties')
    end

    it 'sets the cidr block' do
      expect(subject['CidrBlock']).to eq('10.10.11.0/24')
    end

    it 'sets the availability zone' do
      expect(subject['AvailabilityZone']).to eq('us-east-1a')
    end

    it 'sets a subnet as public' do
      expect(subject['MapPublicIpOnLaunch']).to be(true)
    end

    it 'sets tags' do
      expect(subject['Tags']).to include(hash_including('Key' => 'Name', 'Value' => 'subnet'))
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end