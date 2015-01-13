require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::SubnetRouteTableAssociation
        ##
        class EC2SubnetRouteTableAssociation < Resource
          def initialize(*args)
            super
            type 'AWS::EC2::SubnetRouteTableAssociation'
          end

          def route_table(value)
            property('RouteTableId', value)
          end

          def subnet(value)
            property('SubnetId', value)
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_subnet_route_table_association(name, &block)
        r = Model::Template::Resource::EC2SubnetRouteTableAssociation.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
