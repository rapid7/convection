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

    describe 'after update tasks' do
      include_context 'with a CollectAvailabilityZonesTask defined'
      include_context 'with a mock CloudFormation client'
      include_context 'with a mock EC2 client'

      before do
        allow(Aws::CloudFormation::Client).to receive(:new).and_return(cf_client)
        allow(Aws::EC2::Client).to receive(:new).and_return(ec2_client)
      end
      let(:task) { CollectAvailabilityZonesTask.new }
      subject do
        scope = self
        stack = Convection::Control::Stack.new('EC2 VPC Test Stack', template) do
          after_update_task scope.task
        end
        allow(stack).to receive(:exist).and_return(true)
        allow(stack).to receive(:exist?).and_return(true)
        stack
      end

      it 'is registered after Stack#apply is called' do
        expect(subject.tasks[:after_update]).to_not be_empty
      end

      it 'is executed on Stack#apply' do
        subject.apply

        expect(task.availability_zones).to include(a_string_starting_with('eu-central-1'))
      end

      it 'is deregistered after Stack#apply is called' do
        subject.apply

        expect(subject.tasks[:after_update]).to be_empty
      end
    end
  end
end
