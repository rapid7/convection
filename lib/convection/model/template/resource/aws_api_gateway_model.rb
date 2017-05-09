require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::Model
        ##
        class ApiGatewayModel < Resource
          type 'AWS::ApiGateway::Model'
          property :content_type, 'ContentType'
          property :description, 'Description'
          property :name, 'Name'
          property :rest_api_id, 'RestApiId'
          property :schema, 'Schema' # JSON object
        end
      end
    end
  end
end
