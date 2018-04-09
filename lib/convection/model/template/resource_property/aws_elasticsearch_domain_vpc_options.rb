require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticsearch-domain-vpcoptions.html
        # VPC Options Property Type}
        class ElasticsearchDomainVPCOptions < ResourceProperty
          property :security_group_ids, 'SecurityGroupIds', :type => :list
          property :subnet_ids, 'SubnetIds', :type => :list
        end
      end
    end
  end
end
