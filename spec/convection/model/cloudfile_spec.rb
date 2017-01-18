require 'spec_helper'
require 'stringio'

module Convection::Model
  describe Cloudfile do
    describe 'stack' do
      subject do
        klass = Class.new
        klass.extend(Convection::DSL::Cloudfile)
        klass
      end

      it 'can get cloud name' do
        subject.name 'test-1'
        expect(subject.name).to eq('test-1')
      end

      it 'can get region name' do
        subject.region 'eu-central-1'
        expect(subject.region).to eq('eu-central-1')
      end

      it 'can exclude_availability_zones an availability_zone' do
        subject.exclude_availability_zones %w(eu-central-1a)
        expect(subject.exclude_availability_zones).to contain_exactly('eu-central-1a')
      end
    end
  end
end
