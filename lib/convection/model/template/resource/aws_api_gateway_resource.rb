require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::Resource
        ##
        class ApiGatewayResource < Resource
          type 'AWS::ApiGateway::Resource'
          property :parent_id, 'ParentId'
          property :path_part, 'PathPart'
          property :rest_api_id, 'RestApiId'
        end
      end
    end
  end
end
