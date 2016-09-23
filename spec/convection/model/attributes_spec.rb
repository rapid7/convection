require 'spec_helper'

module Convection::Model
  describe Attributes do
    subject { Attributes.new }

    describe '#fetch' do
      it 'raises a key error if the key was not defined' do
        expect { subject.fetch('<stack-name>', '<attribute-key>') }.to raise_error(KeyError)
      end

      ['<truthy object>', true, false].each do |default|
        it "supports #{default.inspect} as the default value when no value was set" do
          expect { subject.fetch('<stack-name>', '<attribute-key>', default) }.to_not raise_error
        end

        it "supports #{default.inspect} as a default value" do
          observed = subject.fetch('<stack-name>', '<attribute-key>', default)
          expect(observed).to eq(default)
        end
      end

      ['truthy object', true, false, nil].each do |value|
        it "does not raise a key error when #{value.inspect} was previously set" do
          subject.set('<stack-name>', '<attribute-key>', value)

          expect { subject.fetch('<stack-name>', '<attribute-key>') }.to_not raise_error
        end

        it "supports #{value.inspect} as a return value" do
          subject.set('<stack-name>', '<attribute-key>', value)

          observed = subject.fetch('<stack-name>', '<attribute-key>')
          expect(observed).to eq(value)
        end
      end
    end
  end
end
