require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElasticLoadBalancingV2::TargetGroup
        ##
        class ELBV2TargetGroup < Resource
          include Model::Mixin::Taggable

          type 'AWS::ElasticLoadBalancingV2::TargetGroup', :elbv2_target_group
          property :health_check_interval_seconds, 'HealthCheckIntervalSeconds'
          property :health_check_path, 'HealthCheckPath'
          property :health_check_port, 'HealthCheckPort'
          property :health_check_protocol, 'HealthCheckProtocol'
          property :health_check_timeout_seconds, 'HealthCheckTimeoutSeconds'
          property :healthy_threshold_count, 'HealthyThresholdCount'
          property :matcher, 'Matcher', :type => :hash
          property :name, 'Name'
          property :port, 'Port'
          property :protocol, 'Protocol'
          property :target_group_attributes, 'TargetGroupAttributes', :type => :list
          property :targets, 'Targets', :type => :list
          property :unhealthy_threshold_count, 'UnhealthyThresholdCount', :type => :list
          property :vpc_id, 'VpcId'
          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
