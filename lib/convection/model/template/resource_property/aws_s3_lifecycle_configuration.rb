require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-lifecycleconfig.html
        # Amazon S3 Lifecycle Configuration}
        class S3LifecycleConfiguration < ResourceProperty
          property :rules, 'Rules', :type => :list

          def rule(&block)
            rule = ResourceProperty::S3LifecycleConfigurationRule.new(self)
            rule.instance_exec(&block) if block
            rules << rule
          end
          alias_method :lifecycle_rule, :rule
        end
      end
    end
  end
end
