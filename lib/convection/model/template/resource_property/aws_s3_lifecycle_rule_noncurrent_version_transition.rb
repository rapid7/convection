require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-lifecycleconfig-rule-noncurrentversiontransition.html
        # Amazon S3 Lifecycle Rule NoncurrentVersionTransition}
        class S3LifecycleRuleNoncurrentVersionTransition < ResourceProperty
          property :storage_class, 'StorageClass'
          property :transition_in_days, 'TransitionInDays'
        end
      end
    end
  end
end
