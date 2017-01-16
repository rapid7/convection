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

    describe 'after delete tasks' do
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
        Convection::Control::Stack.new('EC2 VPC Test Stack', template) do
          after_delete_task scope.task
        end
      end

      it 'is registered before Stack#delete is called' do
        expect(subject.tasks[:after_delete]).to_not be_empty
      end

      it 'is executed on Stack#delete' do
        subject.delete

        expect(task.availability_zones).to include(a_string_starting_with('eu-central-1'))
      end

      it 'is deregistered after Stack#delete is called' do
        subject.delete

        expect(subject.tasks[:after_delete]).to be_empty
      end
    end
  end
end
