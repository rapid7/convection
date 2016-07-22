require 'spec_helper'

class Convection::Model::Template::Resource
  describe EC2DHCPOptions do
    let(:template) do
      Convection.template do
        ec2_dhcp_options 'TestOptions' do
          domain_name 'example.com'
          domain_name_servers  '10.0.0.1', '10.0.0.2'
          netbios_name_servers '10.0.0.1', '10.0.0.2'
          netbios_node_type 1
          ntp_servers '10.0.0.1', '10.0.0.2'
          tag 'Name', 'Test'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('TestOptions')
        .fetch('Properties')
    end

    it 'sets the DomainName' do
      expect(subject['DomainName']).to eq('example.com')
    end

    it 'sets the DomainNameServers' do
      expect(subject['DomainNameServers']).to match_array(['10.0.0.1', '10.0.0.2'])
    end

    it 'sets the NetbiosNameServers' do
      expect(subject['NetbiosNameServers']).to match_array(['10.0.0.1', '10.0.0.2'])
    end

    it 'sets the NetbiosNodeType' do
      expect(subject['NetbiosNodeType']).to eq(1)
    end

    it 'sets the NtpServers' do
      expect(subject['NtpServers']).to match_array(['10.0.0.1', '10.0.0.2'])
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
