require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-lifecycleconfig-rule-transition.html
        # Amazon S3 Lifecycle Rule Transition}
        class S3LifecycleRuleTransition < ResourceProperty
          property :storage_class, 'StorageClass'
          property :transition_date, 'TransitionDate'
          property :transition_in_days, 'TransitionInDays'
        end
      end
    end
  end
end
