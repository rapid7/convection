require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-websiteconfiguration-routingrules.html
        # Amazon S3 Website Configuration Routing Rule}
        class S3WebsiteConfigurationRoutingRule < ResourceProperty
          property :redirect_rul, 'RedirectRule'
          property :routing_rule_cond, 'RoutingRuleCondition'

          def redirect_rule(&block)
            redr = ResourceProperty::S3WebsiteConfigurationRoutingRuleRedirectRule.new(self)
            redr.instance_exec(&block) if block
            properties['RedirectRule'].set(redr)
          end

          def routing_rule_condition(&block)
            cond = ResourceProperty::S3WebsiteConfigurationRoutingRuleRoutingRuleCondition.new(self)
            cond.instance_exec(&block) if block
            properties['RoutingRuleCondition'].set(cond)
          end
        end
      end
    end
  end
end
