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

          property :description, 'GroupDescription'
          property :vpc, 'EC2VpcId'

          def initialize(*args)
            super
            type 'AWS::RDS::DBSecurityGroup'
            @properties['DBSecurityGroupIngress'] = []
          end

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

  module DSL
    ## Add DSL method to template namespace
    module Template
      def rds_security_group(name, &block)
        r = Model::Template::Resource::RDSDBSecurityGroup.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end

    end
  end
end
