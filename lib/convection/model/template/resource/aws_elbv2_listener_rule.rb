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
          property :conditions, 'Conditions', :type => :list
          property :listener_arn, 'ListenerArn'
          property :priority, 'Priority'
        end
      end
    end
  end
end
