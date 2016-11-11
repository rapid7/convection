require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata.html
        # EC2 Spot Fleet Request Config Data Property Type}
        class EC2SpotFleetRequestConfigData < ResourceProperty
          property :allocation_strategy, 'AllocationStrategy'
          property :excess_capacity_termination_policy, 'ExcessCapacityTerminationPolicy'
          property :iam_fleet_role, 'IamFleetRole'
          property :launch_specifications, 'LaunchSpecifications', :type => :list
          property :spot_price, 'SpotPrice'
          property :target_capacity, 'TargetCapacity'
          property :terminate_instances_with_expiration, 'TerminateInstancesWithExpiration'
          property :valid_from, 'ValidFrom'
          property :valid_until, 'ValidUntil'

          def launch_specification (&block)
            launch_specification = ResourceProperty::EC2SpotFleetRequestConfigDataLaunchSpecifications.new(self)
            launch_specification.instance_exec(&block) if block
            launch_specifications << launch_specification
          end
        end
      end
    end
  end
end
