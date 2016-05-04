require 'test_helper'

class TestTasksWithEc2 < Minitest::Test
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

  def test_before_create_tasks
    cf_client = Minitest::Mock.new
    ec2_client = Minitest::Mock.new
    Aws::CloudFormation::Client.stub :new, cf_client do
      any_args = [->(*) { true }]
      cf_client.expect(:create_stack, nil, any_args)
      cf_client.expect(:describe_stacks, nil)
      def cf_client.describe_stacks(*)
        context = nil # we don't need any request context here.
        raise Aws::CloudFormation::Errors::ValidationError.new(context, 'Stack does not exist.')
      end

      Aws::EC2::Client.stub :new, ec2_client do
        task = CollectAvailabilityZonesTask.new
        stack = ::Convection::Control::Stack.new('EC2 VPC Test Stack', @template) do
          before_create_task task
        end
        def stack.availability_zones
          %w(us-east-1 us-west-1 eu-central-1 eu-west-1)
        end

        refute_empty stack.tasks[:before_create]

        stack.apply
        assert_empty stack.tasks[:before_create]
      end
    end
  end
end
