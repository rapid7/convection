require 'spec_helper'
require 'stringio'

module Convection::Model
  describe Cloudfile do
    let(:template) do
      Convection.template do
        description 'EC2 VPC Test Template'

        ec2_vpc 'TargetVPC' do
          network '10.0.0.0'
          subnet_length 24
          enable_dns
        end
      end
    end

    describe 'stack' do
      subject do
        # initialize does too much to call that directly
        # setup only what we need for testing... :/
        class TestCloudfile < Convection::Model::Cloudfile
          def initialize(_)
            @attributes = Convection::Model::Attributes.new
            @stacks = {}
            @deck = []
            @stack_groups = {}
            @thread_count ||= 2
          end
        end
        TestCloudfile.new(nil)
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

      it 'can get default exclude_availability_zones' do
        subject.stack('test-stack', template, :region => 'us-east-1')
        stack = subject.stacks['test-stack']
        expect(stack.exclude_availability_zones).to match_array([])
      end
    end
  end
end
