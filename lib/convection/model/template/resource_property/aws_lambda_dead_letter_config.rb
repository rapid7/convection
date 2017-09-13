require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-function-deadletterconfig.html
        # Lambda Function DeadLetterConfig}
        class LambdaDeadLetterConfig < ResourceProperty
          property :target_arn, 'TargetArn'
        end
      end
    end
  end
end
