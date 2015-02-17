require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::RDS::DBSubnetGroup
        ##
        class RDSDBSubnetGroup< Resource
          include Model::Mixin::Taggable

          def initialize(*args)
            super
            type AWS::RDS::DBSubnetGroup
          end

          def db_subnet_group_description(value)
              property('DBSubnetGroupDescription', value)
          end

          def subnet_ids(value)
              property('SubnetIds', value)
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
      def db_subnet_group(name, &block)
        r = Model::Template::Resource::RDSDBSubnetGroup.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
