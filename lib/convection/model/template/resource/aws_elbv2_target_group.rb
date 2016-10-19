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
          alias_method :target_descriptions, :targets
          property :unhealthy_threshold_count, 'UnhealthyThresholdCount'
          property :vpc_id, 'VpcId'

          # Append an attribute to target_group_attributes
          def target_group_attribute(&block)
            attribute = ResourceProperty::ELBV2TargetGroupAttribute.new(self)
            attribute.instance_exec(&block) if block
            target_group_attributes << attribute
          end

          # Append a target_description to targets
          def target(&block)
            target = ResourceProperty::ELBV2TargetGroupTargetDescription.new(self)
            target.instance_exec(&block) if block
            targets << target
          end
          alias_method :target_description, :target

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
