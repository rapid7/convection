require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::ApiKey
        ##
        class ApiGatewayApiKey < Resource

          type 'AWS::ApiGateway::ApiKey'
          property :description, 'Description'
          property :enabled, 'Enabled'
          property :name, 'Name'
          property :stage_keys, 'StageKeys', :type => :list # [ StageKey, ... ]

          def stage_key(&block)
            s = ResourceProperty::ApiGatewayApiKeyStageKey.new(self)
            s.instance_exec(&block) if block
            stage_keys << s
          end
        end
      end
    end
  end
end
