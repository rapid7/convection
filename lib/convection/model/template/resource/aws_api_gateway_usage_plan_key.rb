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
          property :key_id, 'KeId'
          property :key_type, 'KeyType'
          property :authorizer_id, 'AuthorizerId'
        end
      end
    end
  end
end
