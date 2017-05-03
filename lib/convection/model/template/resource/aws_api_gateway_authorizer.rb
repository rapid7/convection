require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::Authorizer
        ##
        class ApiGatewayAuthorizer < Resource

          type 'AWS::ApiGateway::Authorizer'
          property :authorizer_credentials, 'AuthorizerCredentials'
          property :authorizer_result_ttl_in_seconds, 'AuthorizerResultTtlInSeconds'
          property :authorizer_uri, 'AuthorizerUri'
          property :identity_source, 'IdentitySource'
          property :identity_validation_expression, 'IdentityValidationExpression'
          property :name, 'Name'
          property :provider_arns, 'ProviderARNs', :type => :list # [ String, ... ],
          property :request_api_id, 'RestApiId'
          property :type, 'Type'
        end
      end
    end
  end
end
