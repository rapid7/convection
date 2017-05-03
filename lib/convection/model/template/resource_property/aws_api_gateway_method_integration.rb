require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-apitgateway-method-integration.html
        # API Gateway Method Integration Property Type}
        class ApiGatewayMethodIntegration < ResourceProperty
          property :cache_key_parameters, 'CacheKeyParameters', :type => :list # [ String, ... ],
          property :cache_namespace, 'CacheNamespace'
          property :credentials, 'Credentials'
          property :integration_http_method, 'IntegrationHttpMethod'
          property :integration_responses, 'IntegrationResponses', :type => :list # [ IntegrationResponse, ... ],
          property :passthrough_behavior, 'PassthroughBehavior'
          property :request_parameters, 'RequestParameters', :type => :hash # { String:String, ... },
          property :request_templates, 'RequestTemplates', :type => :hash # { String:String, ... },
          property :type, 'Type'
          property :uri, 'Uri'

          def integration_response(&block)
            i = ResourceProperty::ApiGatewayMethodIntegrationIntegrationResponse.new(self)
            i.instance_exec(&block) if block
            integration_responses << i
          end
        end
      end
    end
  end
end
