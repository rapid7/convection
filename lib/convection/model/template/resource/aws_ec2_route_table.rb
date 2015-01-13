require_relative '../resource'

module Convection

  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_route_table(name, &block)
        r = Model::Template::Resource::EC2RouteTable.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end

      module Resource
        ##
        # DSL For routes
        ##
        module EC2RouteTable
          def route(name, &block)
            r = Model::Template::Resource::EC2Route.new("#{ self.name }Route#{ name }", @template)
            r.route_table_id(reference)

            r.instance_exec(&block) if block
            @template.resources[r.name] = r
          end
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::RouteTable
        ##
        class EC2RouteTable < Resource
          include DSL::Template::Resource::EC2RouteTable
          include Model::Mixin::Taggable

          def initialize(*args)
            super
            type 'AWS::EC2::RouteTable'
          end

          def vpc_id(value)
            property('VpcId', value)
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
