require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::ClientCertificate
        ##
        class ApiGatewayClientCertificate < Resource
          type 'AWS::ApiGateway::ClientCertificate'
          property :description, 'Description'
        end
      end
    end
  end
end
