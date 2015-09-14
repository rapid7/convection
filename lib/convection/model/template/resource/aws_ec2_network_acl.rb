require_relative '../resource'

module Convection
  module DSL
    module Template
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

          type 'AWS::EC2::NetworkAcl'
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
