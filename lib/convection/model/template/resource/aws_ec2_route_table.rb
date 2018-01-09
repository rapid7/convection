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

          def to_hcl_json(*)
            tf_record_tags = tags.reject { |_, v| v.nil? }

            tf_record_attrs = {
              vpc_id: vpc,
              tags: tf_record_tags
            }

            tf_record_attrs.reject! { |_, v| v.nil? }

            tf_record = {
              aws_route_table: {
                name.underscore => tf_record_attrs
              }
            }

            { resource: tf_record }.to_json
          end

          def terraform_import_commands(module_path: 'root')
            prefix = "#{module_path}." unless module_path == 'root'
            resource_id = stack.resources[name] && stack.resources[name].physical_resource_id
            commands = ['# Import the Route Table record:']
            commands << "terraform import #{prefix}aws_route_table.#{name.underscore} #{resource_id}"
            commands
          end
        end
      end
    end
  end
end
