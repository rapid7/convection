require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-replicationconfiguration.html}
        # Amazon S3 Replication Configuration
        class S3ReplicationConfiguration < ResourceProperty
          property :role, 'Role'
          property :rules, 'Rules', :type => :list

          def rule(&block)
            rule = ResourceProperty::S3ReplicationConfigurationRule.new(self)
            rule.instance_exec(&block) if block
            rules << rule
          end
        end
      end
    end
  end
end
