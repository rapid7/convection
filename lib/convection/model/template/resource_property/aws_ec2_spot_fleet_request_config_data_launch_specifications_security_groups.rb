require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-securitygroups.html
        # EC2 spot fleet request config data launch specifications security groups Property Type}
        class EC2SpotFleetRequestConfigDataLaunchSpecificationsSecurityGroups < ResourceProperty
          property :group_id, 'GroupId'
        end
      end
    end
  end
end
