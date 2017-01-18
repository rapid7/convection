require 'spec_helper'

module Convection::Control
  describe Stack do
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
      include_context 'with a mock CloudFormation client'
      include_context 'with a mock EC2 client'

      before do
        allow(Aws::CloudFormation::Client).to receive(:new).and_return(cf_client)
        allow(Aws::EC2::Client).to receive(:new).and_return(ec2_client)
      end
      subject do
        Convection::Control::Stack.new('EC2 VPC Test Stack', template)
      end

      it 'availability_zones are stored in an array' do
        expect(subject.availability_zones).to be_a(Array)
      end

      it 'availability_zones are in the same region' do
        azs = subject.availability_zones
        azs.map! { |r| r.match(/(\w{2}-\w+-\d)/)[1] }
        azs.uniq!
        expect(azs.size).to be(1)
      end

      it 'availability_zones can be ignored' do
        subject.exclude_availability_zones = %w(eu-central-1a)
        expect(subject.availability_zones).to contain_exactly('eu-central-1b')
      end

      it 'multiple availability_zones can be ignored' do
        subject.exclude_availability_zones = %w(eu-central-1a eu-central-1b)
        expect(subject.availability_zones).to contain_exactly
      end

      it 'remove all availability_zones fails' do
        subject.exclude_availability_zones = %w(eu-central-1a eu-central-1b)
        b = proc do
          puts 'hi'
        end
        expect { subject.availability_zones(&b) }.to raise_exception(RuntimeError, /AvailabilityZones/)
      end

      it 'can get default availability_zones' do
        expect(subject.availability_zones).to contain_exactly('eu-central-1a', 'eu-central-1b')
      end
    end
  end
end
