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
          # http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-listenerrule.html
          property :actions, 'Actions', :type => :list
          property :conditions, 'Conditions', :type => :list
          property :listener_arn, 'ListenerArn'
          property :priority, 'Priority'

          # Append an action
          def action(&block)
            action = ResourceProperty::ELBV2ListenerRuleAction.new(self)
            action.instance_exec(&block) if block
            actions << action
          end

          # Append a condition
          def rule_condition(&block)
            condition = ResourceProperty::ELBV2ListenerRuleCondition.new(self)
            condition.instance_exec(&block) if block
            conditions << condition
          end

        end
      end
    end
  end
end
