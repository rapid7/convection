require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-apitgateway-deployment-stagedescription-methodsetting.html
        # API Gateway Deployment StageDescription MethodSetting Property Type}
        class ApiGatewayDeploymentStageDescriptionMethodSetting < ResourceProperty
          property :cache_data_encrypted, 'CacheDataEncrypted'
          property :cache_ttl_in_seconds, 'CacheTtlInSeconds'
          property :caching_enabled, 'Caching_enabled'
          property :data_trace_enabled, 'DataTraceEnabled'
          property :http_method, 'HttpMethod'
          property :logging_level, 'LoggingLevel'
          property :metrics_enabled, 'MetricsEnabled'
          property :resource_path, 'ResourcePath'
          property :throttling_burst_limit, 'ThrottlingBurstLimit'
          property :throttling_rate_limit, 'ThrottlingRateLimit'
        end
      end
    end
  end
end
