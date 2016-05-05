require 'test_helper'

class TestAfterCreateTasks < Minitest::Test
  class CollectAvailabilityZonesTask
    attr_writer :availability_zones

    def availability_zones
      @availability_zones ||= []
    end

    def call(stack)
      self.availability_zones += stack.availability_zones
    end

    def success?
      availability_zones.any?
    end
  end

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

  def test_after_create_task_is_registered
    Aws::CloudFormation::Client.stub :new, mock_cloudformation_client do
      Aws::EC2::Client.stub :new, mock_ec2_client do
        # when - a stack is initialized with a after_create_task
        stack = ::Convection::Control::Stack.new('EC2 VPC Test Stack', @template) do
          after_create_task CollectAvailabilityZonesTask.new
        end

        # then - at least one task should be present
        refute_empty stack.tasks[:after_create]
      end
    end
  end

  def test_after_create_task_is_executed
    Aws::CloudFormation::Client.stub :new, mock_cloudformation_client do
      Aws::EC2::Client.stub :new, mock_ec2_client do
        # given - a stack initialized with a after_create_task
        task = CollectAvailabilityZonesTask.new
        stack = ::Convection::Control::Stack.new('EC2 VPC Test Stack', @template) do
          after_create_task task
        end

        # when - any changes to the stack are applied
        stack.apply

        # then - the task should have been executed
        assert_includes task.availability_zones, 'eu-central-1'
      end
    end
  end

  def test_after_create_task_is_deregistered
    Aws::CloudFormation::Client.stub :new, mock_cloudformation_client do
      Aws::EC2::Client.stub :new, mock_ec2_client do
        # given - a stack initialized with a after_create_task
        stack = ::Convection::Control::Stack.new('EC2 VPC Test Stack', @template) do
          after_create_task CollectAvailabilityZonesTask.new
        end

        # when - any changes to the stack are applied
        stack.apply

        # then - the task should have been deregistered
        assert_empty stack.tasks[:after_create]
      end
    end
  end

  private

  def mock_cloudformation_client
    cf_client = Minitest::Mock.new
    any_args = [->(*) { true }]
    cf_client.expect(:create_stack, nil, any_args)
    cf_client.expect(:describe_stacks, nil)
    def cf_client.describe_stacks(*)
      context = nil # we don't need any request context here.
      raise Aws::CloudFormation::Errors::ValidationError.new(context, 'Stack does not exist.')
    end

    cf_client
  end

  def mock_ec2_client
    zones = %w(eu-central-1 eu-west-1).map do |zone|
      mock = Minitest::Mock.new
      mock.expect(:zone_name, zone)
    end
    availability_zone_description = Minitest::Mock.new
    availability_zone_description.expect(:availability_zones, zones)

    ec2_client = Minitest::Mock.new
    ec2_client.expect(:describe_availability_zones, availability_zone_description)
    ec2_client
  end
end
