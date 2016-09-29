require 'spec_helper'

class Convection::Model::Template::Resource
  describe AutoScalingGroup do
    subject do
      parent = double(:template)
      allow(parent).to receive(:template).and_return(parent)

      described_class.new('MyAutoScalingGroup', parent)
    end

    it 'should not render tags when none have been defined' do
      expect(subject.render['Properties']['Tags']).to be_nil
    end

    it 'renders a regular tag' do
      subject.tag '<tag-name>', '<tag-value>'
      expect(subject.render['Properties']['Tags']).to include(a_hash_including('Key' => '<tag-name>'))
    end

    it 'renders a tag that should be propagated at launch' do
      subject.tag '<tag-name>', '<tag-value>', propagate_at_launch: true
      expect(subject.render['Properties']['Tags']).to include(a_hash_including('Key' => '<tag-name>', 'PropagateAtLaunch' => true))
    end

    it 'renders a tag that should not be propagated at launch' do
      subject.tag '<tag-name>', '<tag-value>', propagate_at_launch: false
      expect(subject.render['Properties']['Tags']).to include(a_hash_including('Key' => '<tag-name>', 'PropagateAtLaunch' => false))
    end
  end
end
