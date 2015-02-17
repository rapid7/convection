require_relative '../resource'

module Convection
  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_internet_gateway(name, &block)
        r = Model::Template::Resource::EC2InternetGateway.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end

      module Resource
        ##
        # Add DSL for VPCGatewayAttachment
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

          def initialize(*args)
            super
            type 'AWS::EC2::InternetGateway'
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
