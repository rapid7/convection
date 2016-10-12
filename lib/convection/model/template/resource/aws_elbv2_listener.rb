require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElasticLoadBalancingV2::Listener
        ##
        class ELBV2Listener < Resource
          type 'AWS::ElasticLoadBalancingV2::Listener', :elbv2_listener
          property :certificates, 'Certificates', :type => :list
          property :default_actions, 'DefaultActions', :type => :list
          property :load_balancer_arn, 'LoadBalancerArn'
          property :port, 'Port'
          property :protocol, 'Protocol'
          property :ssl_policy, 'SslPolicy'

          # FIXME: handle certificates

          # Append an action to default_actions
          def default_action(&block)
            action = ResourceProperty::ELBV2ListenerDefaultAction.new(self)
            action.instance_exec(&block) if block
            default_actions << action
        end
      end
    end
  end
end
