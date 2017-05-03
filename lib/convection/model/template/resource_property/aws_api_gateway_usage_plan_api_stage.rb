require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-apigateway-usageplan-apistage.html
        # API Gateway UsagePlan ApiStage Property Type}
        class ApiGatewayUsagePlanApiStage < ResourceProperty
          property :api_id, 'ApiId'
          property :stage, 'Stage'
        end
      end
    end
  end
end
