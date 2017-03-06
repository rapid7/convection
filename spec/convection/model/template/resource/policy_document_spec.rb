require 'spec_helper'

module Convection::Model::Mixin
  describe Policy do
    let(:template) { double(:template) }
    subject { described_class.new(name: 'test-policy', template: template) }

    it 'does not set Id on #document if absent' do
      expect(subject.document['Id']).to be_nil
    end

    it 'sets Id on #document if provided' do
      subject.id('MyDocumentId')
      expect(subject.document['Id']).to eq('MyDocumentId')
    end
  end
end
