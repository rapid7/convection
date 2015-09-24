require_relative '../resource'

module Convection
  module DSL
    module Template
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

          type 'AWS::EC2::RouteTable'
          property :vpc, 'VpcId'

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
