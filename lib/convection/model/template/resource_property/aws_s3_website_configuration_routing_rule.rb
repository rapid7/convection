require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-websiteconfiguration-routingrules.html
        # Amazon S3 Website Configuration Routing Rule}
        class S3WebsiteConfigurationRoutingRule < ResourceProperty
          property :redirect_rule, 'RedirectRule'
          property :routing_rule_condition, 'RoutingRuleCondition'

          def redirect_rule(&block)
            rule = ResourceProperty::S3WebsiteConfigurationRedirectRule.new(self)
            rule.instance_exec(&block) if block
            properties['RedirectRule'].set(rule)
          end

          def routing_rule_condition(&block)
            condition = ResourceProperty::S3WebsiteConfigurationRoutingRuleCondition.new(self)
            condition.instance_exec(&block) if block
            properties['RoutingRuleCondition'].set(condition)
          end
        end
      end
    end
  end
end
