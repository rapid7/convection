require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-apigateway-usageplan-quotasettings.html
        # API Gateway UsagePlan QuotaSettings Property Type}
        class ApiGatewayUsagePlanQuotaSettings < ResourceProperty
          property :limit, 'Limit'
          property :offset, 'Offset'
          property :period, 'Period'
        end
      end
    end
  end
end
