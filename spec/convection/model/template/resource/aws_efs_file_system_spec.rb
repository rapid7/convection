require 'spec_helper'

class Convection::Model::Template::Resource
  describe EFSFileSystem do
    subject do
      parent = double(:template)
      allow(parent).to receive(:template).and_return(parent)

      described_class.new('MyEFSFileSystem', parent)
    end

    it 'allows FileSystemTags to be set' do
      expect(subject.render['Properties']['FileSystemTags']).to be_nil
      subject.file_system_tags ['tag-1', 'tag-2']
      expect(subject.render['Properties']['FileSystemTags']).to eq(['tag-1', 'tag-2'])
    end

    it 'allows PerformanceMode to be set' do
      expect(subject.render['Properties']['PerformanceMode']).to be_nil
      subject.performance_mode 'maxIO'
      expect(subject.render['Properties']['PerformanceMode']).to eq('maxIO')
    end

    it 'allows individual FileSystemTags to be set' do
      expect(subject.render['Properties']['FileSystemTags']).to be_nil
      subject.file_system_tag do
        key 'key-1'
        value 'value-1'
      end
      subject.file_system_tag do
        key 'key-2'
        value 'value-2'
      end
      expect(subject.render['Properties']['FileSystemTags']).to eq([{
        'Key'=>'key-1', 'Value'=>'value-1'
      },{
        'Key'=>'key-2', 'Value'=>'value-2'
      }])
    end
  end
end
