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

          def initialize(*args)
            super
            type 'AWS::RDS::DBSecurityGroup'
          end

          def ec2_vpc_id(value)
            property('EC2VpcId', value)
          end

          def db_security_group_ingress(value)
            property('DBSecurityGroupIngress', value)
          end

          def group_description(value)
            property('GroupDescription', value)
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
      def db_security_group(name, &block)
        r = Model::Template::Resource::RDSDBSecurityGroup.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
