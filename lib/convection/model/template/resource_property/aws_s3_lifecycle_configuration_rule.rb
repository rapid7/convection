require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-lifecycleconfig-rule.html
        # Amazon S3 Lifecycle Rule}
        class S3LifecycleConfigurationRule < ResourceProperty
          property :expiration_date, 'ExpirationDate'
          property :expiration_in_days, 'ExpirationInDays'
          property :id, 'Id'
          property :noncurrent_version_expiration_in_days, 'NoncurrentVersionExpirationInDays'
          property :noncurrent_version_transitions, 'NoncurrentVersionTransitions', :type => :list
          property :prefix, 'Prefix'
          property :status, 'Status'
          property :transitions, 'Transitions', :type => :list

          def transition(&block)
            transition = ResourceProperty::S3LifecycleRuleTransition.new(self)
            transition.instance_exec(&block) if block
            transitions << transition
          end

          def noncurrent_version_transition(&block)
            noncurrent_version_transition = ResourceProperty::S3LifecycleRuleNoncurrentVersionTransition.new(self)
            noncurrent_version_transition.instance_exec(&block) if block
            noncurrent_version_transitions << noncurrent_version_transition
          end
        end
      end
    end
  end
end
