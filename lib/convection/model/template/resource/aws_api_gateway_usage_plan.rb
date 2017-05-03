require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::UsagePlan
        ##
        class ApiGatewayUsagePlan < Resource

          type 'AWS::ApiGateway::UsagePlan'
          property :api_stages, 'ApiStages', :type => :list # [ ApiStage, ... ]
          property :description, 'Description'
          property :quota_prop, 'Quota' # QuotaSetting
          property :throttle_prop, 'Throttle' # ThrottleSetting
          property :usage_plan_name, 'UsagePlanName'

          def api_stage(&block)
            r = ResourceProperty::ApiGatewayUsagePlanApiStage.new(self)
            r.instance_exec(&block) if block
            api_stages << r
          end

          def quota(&block)
            i = ResourceProperty::ApiGatewayUsagePlanQuotaSettings.new(self)
            i.instance_exec(&block) if block
            properties['Quota'].set(i)
          end

          def throttle(&block)
            i = ResourceProperty::ApiGatewayUsagePlanThrottleSettings.new(self)
            i.instance_exec(&block) if block
            properties['Throttle'].set(i)
          end
        end
      end
    end
  end
end
