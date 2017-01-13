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
        scope = self
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
    end
  end
end
