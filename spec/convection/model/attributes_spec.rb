require 'spec_helper'

module Convection::Model
  describe Attributes do
    subject do
      Attributes.new
    end

    describe '#fetch' do
      it 'returns a value that has been set' do
        subject.set('web-service', 'private', true)

        expect { subject.fetch('web-service', 'private') }.to_not raise_error
      end

      it 'returns false if a value of false has been set' do
        subject.set('web-service', 'private', false)

        expect { subject.fetch('web-service', 'private') }.to_not raise_error
      end

      it 'returns nil if a value of nil has been set' do
        subject.set('web-service', 'private', nil)

        expect { subject.fetch('web-service', 'private') }.to_not raise_error
      end

      it 'raises an exception if no value has been set' do
        expect { subject.fetch('web-service', 'private') }.to raise_error(KeyError)
      end
    end
  end
end
