require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-iaminstanceprofile.html
        # EC2 Block Device Mapping Property Type}
        class EC2SpotFleetRequestConfigDataLaunchSpecificationsIamInstanceProfile < ResourceProperty
          property :arn, 'Arn'
        end
      end
    end
  end
end
