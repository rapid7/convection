require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-function-environment.html}
        class LambdaEnvironment < ResourceProperty
          property :variables, 'Variables'
        end
      end
    end
  end
end
