require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-apitgateway-apikey-stagekey.html
        # API Gateway ApiKey StageKey Property Type}
        class ApiGatewayApiKeyStageKey < ResourceProperty
          property :rest_api_id, 'RestApiId'
          property :stage_name, 'StageName'
        end
      end
    end
  end
end
