require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::Stage
        ##
        class ApiGatewayStage < Resource
          type 'AWS::ApiGateway::Stage'
          property :cache_cluster_enabled, 'CacheClusterEnabled'
          property :cache_cluster_size, 'CacheClusterSize'
          property :client_certificate_id, 'ClientCertificateId'
          property :deployment_id, 'DeploymentId'
          property :description, 'Description'
          property :method_settings, 'MethodSettings', :type => :list # [ MethodSettings, ... ]
          property :rest_api_id, 'RestApiId'
          property :stage_name, 'StageName'
          property :variables, 'Variables', :type => :hash # { String:String, ... }

          def method_setting(&block)
            r = ResourceProperty::ApiGatewayStageMethodSetting.new(self)
            r.instance_exec(&block) if block
            method_settings << r
          end
        end
      end
    end
  end
end
