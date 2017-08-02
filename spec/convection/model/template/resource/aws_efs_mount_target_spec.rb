require 'spec_helper'

class Convection::Model::Template::Resource
  describe EFSMountTarget do
    subject do
      parent = double(:template)
      allow(parent).to receive(:template).and_return(parent)

      described_class.new('MyEFSMountTarget', parent)
    end

    it 'allows FileSystemId to be set' do
      expect(subject.render['Properties']['FileSystemId']).to be_nil
      subject.file_system_id 'fs-1'
      expect(subject.render['Properties']['FileSystemId']).to eq('fs-1')
    end

    it 'allows IpAddress to be set' do
      expect(subject.render['Properties']['IpAddress']).to be_nil
      subject.ip_address '127.0.0.1'
      expect(subject.render['Properties']['IpAddress']).to eq('127.0.0.1')
    end

    it 'allows SecurityGroups to be set' do
      expect(subject.render['Properties']['SecurityGroups']).to be_nil
      subject.security_groups ['sg-1', 'sg-2']
      expect(subject.render['Properties']['SecurityGroups']).to eq(['sg-1', 'sg-2'])
    end

    it 'allows SubnetId to be set' do
      expect(subject.render['Properties']['SubnetId']).to be_nil
      subject.subnet_id 's-1'
      expect(subject.render['Properties']['SubnetId']).to eq('s-1')
    end
  end
end
