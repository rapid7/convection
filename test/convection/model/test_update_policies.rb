require 'test_helper'
require 'json'
require 'pp'

class TestUpdatePolicies < Minitest::Test
  def setup
    @template = ::Convection.template do
      description 'UpdatePolicies Test Template'

      ec2_security_group 'MyEC2SecGroup' do
        ingress_rule(:tcp, 80, 'my.ip.address')
      end

      auto_scaling_launch_configuration 'TestLaunchConfig' do
        image_id 'ami-123'
        instance_type 't2.nano'

        security_group fn_ref('MyEC2SecGroup')
      end

      auto_scaling_auto_scaling_group 'TestAutoScalingGroup' do
        launch_configuration_name fn_ref('TestLaunchConfig')

        update_policy do
          pause_time 'test_time'
          min_instances_in_service 10
          max_batch_size 2
        end
      end
    end
  end

  def from_json
    JSON.parse(@template.to_json)
  end

  def test_update_policy
    json = from_json['Resources']['TestAutoScalingGroup']
    type = json['Type']
    assert_equal 'AWS::AutoScaling::AutoScalingGroup', type

    update_policy = json['UpdatePolicy']
    refute update_policy.nil?, 'UpdatePolicy does not exist in the generated template'

    pause_time = json['UpdatePolicy']['AutoScalingRollingUpdate']['PauseTime']
    assert_equal 'test_time', pause_time

    min_in_service = json['UpdatePolicy']['AutoScalingRollingUpdate']['MinInstancesInService']
    assert_equal 10, min_in_service

    max_batch_size = json['UpdatePolicy']['AutoScalingRollingUpdate']['MaxBatchSize']
    assert_equal 2, max_batch_size
  end
end
