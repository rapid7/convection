require_relative '../resource'
require_relative 'aws_ec2_subnet_route_table_association'

module Convection

  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_subnet(name, &block)
        r = Model::Template::Resource::EC2Subnet.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end

      module Resource
        ##
        # Add DSL for RouteTableAssocaition
        module EC2Subnet
          def route_table(table, &block)
            assoc = Model::Template::Resource::EC2SubnetRouteTableAssociation.new("#{ name }RouteTableAssociation#{ table.name }", @tamplate)
            assoc.route_table(table)
            assoc.subnet(self)

            assoc.instance_exec(&block) if block
            @template.resources[assoc.name] = assoc
          end

          def acl(acl_entity, &block)
            assoc = Model::Template::Resource::EC2SubnetNetworkACLAssociation.new("#{ name }ACLAssociation#{ acl_entity.name }", self)
            assoc.acl(acl_entity)
            assoc.subnet(self)

            assoc.instance_exec(&block) if block
            @template.resources[assoc.name] = assoc
          end
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Subnet
        ##
        class EC2Subnet < Resource
          include DSL::Template::Resource::EC2Subnet
          include Model::Mixin::CIDRBlock
          include Model::Mixin::Taggable

          property :availability_zone, 'AvailabilityZone'
          property :vpc, 'VpcId'

          def initialize(*args)
            super
            type 'AWS::EC2::Subnet'
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
