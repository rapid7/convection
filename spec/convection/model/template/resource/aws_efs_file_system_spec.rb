require 'spec_helper'

class Convection::Model::Template::Resource
  describe EFSFileSystem do
    subject do
      parent = double(:template)
      allow(parent).to receive(:template).and_return(parent)

      described_class.new('MyEFSFileSystem', parent)
    end

    it 'allows FileSystemTags to be set' do
      expected_tags = []
      expected_tags << { 'Key' => 'key-1', 'Value' => 'value-1' }
      expected_tags << { 'Key' => 'key-2', 'Value' => 'value-2' }

      expect(subject.render['Properties']['FileSystemTags']).to be_nil
      subject.tag 'key-1', 'value-1'
      subject.file_system_tag 'key-2', 'value-2'
      expect(subject.render['Properties']['FileSystemTags']).to eq(expected_tags)
    end

    it 'allows PerformanceMode to be set' do
      expect(subject.render['Properties']['PerformanceMode']).to be_nil
      subject.performance_mode 'maxIO'
      expect(subject.render['Properties']['PerformanceMode']).to eq('maxIO')
    end
  end
end
