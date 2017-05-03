require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::Account
        ##
        class ApiGatewayAccount < Resource
          type 'AWS::ApiGateway::Account'
          property :cloud_watch_role_arn, 'CloudWatchRoleArn'
        end
      end
    end
  end
end
