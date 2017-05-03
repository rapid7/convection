require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-apitgateway-deployment-stagedescription.html
        # API Gateway Deployment StageDescription Property Type}
        class ApiGatewayDeploymentStageDescription < ResourceProperty
          property :cache_cluster_enabled, 'CacheClusterEnabled'
          property :cache_cluster_size, 'CacheClusterSize'
          property :cache_data_encrypted, 'CacheDataEncrypted'
          property :cache_ttl_in_seconds, 'CacheTtlInSeconds'
          property :caching_enabled, 'Caching_enabled'
          property :data_trace_enabled, 'DataTraceEnabled'
          property :description, 'Description'
          property :logging_level, 'LoggingLevel'
          property :method_settings, 'MethodSettings', :type => :list # [ MethodSetting, ... ],
          property :metrics_enabled, 'MetricsEnabled'
          property :stage_name, 'StageName'
          property :throttling_burst_limit, 'ThrottlingBurstLimit'
          property :throttling_rate_limit, 'ThrottlingRateLimit'
          property :variables, 'Variables', :type => :hash # { String:String, ... },

          def method_setting(&block)
            m = ResourceProperty::ApiGatewayDeploymentStageDescriptionMethodSetting.new(self)
            m.instance_exec(&block) if block
            integration_responses << m
          end
        end
      end
    end
  end
end
