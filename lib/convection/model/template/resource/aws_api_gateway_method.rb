require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::Method
        ##
        class ApiGatewayMethod < Resource

          type 'AWS::ApiGateway::Method'
          property :api_key_required, 'ApiKeyRequired'
          property :authorization_type, 'AuthorizationType'
          property :authorizer_id, 'AuthorizerId'
          property :http_method, 'HttpMethod'
          property :integration_prop, 'Integration'
          property :method_responses, 'MethodResponses', :type => :list # [ MethodResponse, ... ]
          property :request_model, 'RequestModels', :type => :hash # { String:String, ... }
          property :request_parameter, 'RequestParameters', :type => :hash # { String:Boolean, ... }
          property :resource_id, 'ResourceId'
          property :rest_api_id, 'RestApiId'

          def integration(&block)
            i = ResourceProperty::ApiGatewayMethodIntegration.new(self)
            i.instance_exec(&block) if block
            properties['Integration'].set(i)
          end

          def method_response(&block)
            r = ResourceProperty::ApiGatewayMethodMethodResponse.new(self)
            r.instance_exec(&block) if block
            method_responses << r
          end

        end
      end
    end
  end
end
