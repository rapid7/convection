require 'test_helper'

class TestBeforeDeleteTasks < Minitest::Test
  include TestHelper

  def setup
    @template = ::Convection.template do
      description 'EC2 VPC Test Template'

      ec2_vpc 'TargetVPC' do
        network '10.0.0.0'
        subnet_length 24
        enable_dns
      end
    end
  end

  def test_before_delete_task_is_registered
    Aws::CloudFormation::Client.stub :new, mock_cloudformation_client do
      Aws::EC2::Client.stub :new, mock_ec2_client do
        # when - a stack is initialized with a before_delete_task
        stack = ::Convection::Control::Stack.new('EC2 VPC Test Stack', @template) do
          before_delete_task CollectAvailabilityZonesTask.new
        end

        # then - at least one task should be present
        refute_empty stack.tasks[:before_delete]
      end
    end
  end

  def test_before_delete_task_is_executed
    Aws::CloudFormation::Client.stub :new, mock_cloudformation_client do
      Aws::EC2::Client.stub :new, mock_ec2_client do
        # given - a stack initialized with a before_delete_task
        task = CollectAvailabilityZonesTask.new
        stack = ::Convection::Control::Stack.new('EC2 VPC Test Stack', @template) do
          before_delete_task task
        end

        # when - any changes to the stack are applied
        stack.delete

        # then - the task should have been executed
        assert_includes task.availability_zones, 'eu-central-1'
      end
    end
  end

  def test_before_delete_task_is_deregistered
    Aws::CloudFormation::Client.stub :new, mock_cloudformation_client do
      Aws::EC2::Client.stub :new, mock_ec2_client do
        # given - a stack initialized with a before_delete_task
        stack = ::Convection::Control::Stack.new('EC2 VPC Test Stack', @template) do
          before_delete_task CollectAvailabilityZonesTask.new
        end

        # when - any changes to the stack are applied
        stack.delete

        # then - the task should have been deregistered
        assert_empty stack.tasks[:before_delete]
      end
    end
  end
end
