require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-function-vpcconfig.html}
        class LambdaVpcConfig < ResourceProperty
          property :security_groups, 'SecurityGroupIds', :type => :list
          property :subnets, 'SubnetIds', :type => :list
        end
      end
    end
  end
end
