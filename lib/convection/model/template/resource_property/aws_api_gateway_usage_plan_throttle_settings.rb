require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-apigateway-usageplan-throttlesettings.html
        # API Gateway UsagePlan ThrottleSettings Property Type}
        class ApiGatewayUsagePlanThrottleSettings < ResourceProperty
          property :burst_limit, 'BurstLimit'
          property :rate_limit, 'RateLimit'
        end
      end
    end
  end
end
