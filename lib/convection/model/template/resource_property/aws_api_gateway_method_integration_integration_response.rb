require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-apitgateway-method-integration-integrationresponse.html
        # API Gateway Method Integration IntegrationResponse Property Type}
        class ApiGatewayMethodIntegrationIntegrationResponse < ResourceProperty
          property :response_parameters, 'ResponseParameters', :type => :hash # { String:String, ... },
          property :response_templates, 'ResponseTemplates', :type => :hash # { String:String, ... },
          property :selection_pattern, 'SelectionPattern'
          property :status_code, 'StatusCode'
        end
      end
    end
  end
end
