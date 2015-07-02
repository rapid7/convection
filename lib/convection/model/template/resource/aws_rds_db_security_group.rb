require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::RDS::DBSecurityGroup
        ##
        class RDSDBSecurityGroup < Resource
          include Model::Mixin::Taggable

          type 'AWS::RDS::DBSecurityGroup', :rds_security_group
          property :description, 'GroupDescription'
          property :vpc, 'EC2VpcId'
          property :ingress, 'DBSecurityGroupIngress', :type => :list

          def security_group_ingress(&block)
            # A new code block defines a new ingress group
            @properties['DBSecurityGroupIngress'] << {}
            yield
          end

          def ec2_security_group(group, owner)
            @properties['DBSecurityGroupIngress'].last.merge!(
              { 'EC2SecurityGroupName' => group, 'EC2SecurityGroupOwnerId' => owner }
            )
          end

          def cidr_ip(cidr_block)
            @properties['DBSecurityGroupIngress'].last.merge!({ 'CIDRIP' => cidr_block })
          end

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
