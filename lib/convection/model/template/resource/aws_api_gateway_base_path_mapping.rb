require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::BasePathMapping
        ##
        class ApiGatewayBasePathMapping < Resource
          type 'AWS::ApiGateway::BasePathMapping'
          property :base_path, 'BasePath'
          property :domain_name, 'DomainName'
          property :rest_api_id, 'RestApiId'
          property :stage, 'Stage'
        end
      end
    end
  end
end
