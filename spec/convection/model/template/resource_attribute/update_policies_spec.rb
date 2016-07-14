require 'spec_helper'

class Convection::Model::Template::ResourceAttribute
  describe UpdatePolicy do
    let(:template) do
      Convection.template do
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

    subject do
      template_json
        .fetch('Resources')
        .fetch('TestAutoScalingGroup')
    end

    it 'Type is defined correctly' do
      expect(subject['Type']).to eq('AWS::AutoScaling::AutoScalingGroup')
    end

    it 'UpdatePolicy is defiend' do
      expect(subject['UpdatePolicy']).to_not eq(nil)
    end

    it 'UpdatePolicy PauseTime is defined correctly' do
      expect(subject['UpdatePolicy']['AutoScalingRollingUpdate']['PauseTime']).to eq('test_time')
    end

    it 'UpdatePolicy MinInstancesInService is defined correctly' do
      expect(subject['UpdatePolicy']['AutoScalingRollingUpdate']['MinInstancesInService']).to eq(10)
    end

    it 'UpdatePolicy MaxBatchSize is defined correctly' do
      expect(subject['UpdatePolicy']['AutoScalingRollingUpdate']['MaxBatchSize']).to eq(2)
    end

    # TODO: add tests for TestLaunchConfig and MyEC2SecGroup

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
