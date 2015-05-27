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
            yield
          end

          def ec2_security_group(group, owner)
            @properties['DBSecurityGroupIngress'] << 
	      { 'EC2SecurityGroupName': group, 'EC2SecurityGroupOwnerId': owner }
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
