require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Subnet
        ##
        class EC2VPC < Resource
          include Model::Mixin::Taggable

          def initialize(*args)
            super
            type 'AWS::EC2::VPC'
          end

          def cidr_block(value)
            property('CidrBlock', value)
          end

          def enable_dns(value)
            property('EnableDnsSupport', value)
            property('EnableDnsHostnames', value)
          end

          def instance_tenancy(value)
            property('InstanceTenancy', value)
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
      def ec2_vpc(name, &block)
        r = Model::Template::Resource::EC2VPC.new
        r.instance_exec(&block) if block

        resources[name] = r
      end
    end
  end
end
