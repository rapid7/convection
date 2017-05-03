require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::Deployment
        ##
        class ApiGatewayDeployment < Resource

          type 'AWS::ApiGateway::Deployment'
          property :description, 'Description'
          property :rest_api_id, 'RestApiId'
          property :stage_description_prop, 'StageDescription'
          property :stage_name, 'StageName'

          def stage_description(&block)
            i = ResourceProperty::ApiGatewayDeploymentStageDescription.new(self)
            i.instance_exec(&block) if block
            properties['StageDescription'].set(i)
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
