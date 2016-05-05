require 'simplecov'
SimpleCov.start do
  add_group 'Control', 'lib/convection/control'
  add_group 'Model', 'lib/convection/model'
  add_group 'DSL', 'lib/convection/dsl'
end

gem 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/convection'

module Minitest::Assertions
  def assert_nothing_raised(*)
    yield
  end
end

module TestHelper
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

  private

  def mock_cloudformation_client
    cf_client = Minitest::Mock.new
    any_args = [->(*) { true }]
    cf_client.expect(:create_stack, nil, any_args)
    cf_client.expect(:delete_stack, nil, any_args)
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
