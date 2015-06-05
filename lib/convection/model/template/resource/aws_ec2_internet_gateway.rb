require_relative '../resource'

module Convection
  module DSL
    module Template
      module Resource
        ##
        # Add DSL for VPCGatewayAttachment
        ##
        module EC2InternetGateway
          def attach_to_vpc(vpc, &block)
            a = Model::Template::Resource::EC2VPCGatewayAttachment.new("#{ name }VPCAttachment#{ vpc.name }", self)
            a.vpc(vpc)
            a.internet_gateway(self)

            a.instance_exec(&block) if block
            @template.resources[a.name] = a
          end
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::InternetGateway
        ##
        class EC2InternetGateway < Resource
          include Model::Mixin::Taggable
          include DSL::Template::Resource::EC2InternetGateway
          type 'AWS::EC2::InternetGateway'

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
