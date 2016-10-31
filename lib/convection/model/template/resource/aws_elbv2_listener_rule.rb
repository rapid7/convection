require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElasticLoadBalancingV2::ListenerRule
        ##
        class ELBV2ListenerRule < Resource
          type 'AWS::ElasticLoadBalancingV2::ListenerRule', :elbv2_listener_rule
          property :actions, 'Actions', :type => :list
          # @note This name is used because "conditions" is a function already defined
          #   in {#Convection::Model::Template} and should not be overridden.
          property :rule_conditions, 'Conditions', :type => :list
          property :listener_arn, 'ListenerArn'
          property :priority, 'Priority'

          # Append an action
          def action(&block)
            action = ResourceProperty::ELBV2ListenerRuleAction.new(self)
            action.instance_exec(&block) if block
            actions << action
          end

          # Append a condition
          #
          # @note This name is used because "condition" is a function already defined
          #   in {#Convection::Model::Template} and should not be overridden.
          def rule_condition(&block)
            cond = ResourceProperty::ELBV2ListenerRuleCondition.new(self)
            cond.instance_exec(&block) if block
            rule_conditions << cond
          end
        end
      end
    end
  end
end
