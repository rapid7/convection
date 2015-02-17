require_relative '../resource'

module Convection
  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_network_acl(name, &block)
        r = Model::Template::Resource::EC2NetworkACL.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end

      module Resource
        ##
        # Add DSL helpers to EC2NetworkACL
        ##
        module EC2NetworkACL
          def entry(name, &block)
            acl_entry = Model::Template::Resource::EC2NetworkACLEntry.new("#{ self.name }Entry#{ name }", @template)
            acl_entry.acl(self)

            acl_entry.instance_exec(&block) if block
            @template.resources[acl_entry.name] = acl_entry
          end
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::NetworkACL
        ##
        class EC2NetworkACL < Resource
          include DSL::Template::Resource::EC2NetworkACL
          include Model::Mixin::Taggable

          property :vpc, 'VpcId'

          def initialize(*args)
            super
            type 'AWS::EC2::NetworkAcl'
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
