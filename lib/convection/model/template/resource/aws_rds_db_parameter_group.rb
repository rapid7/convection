require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::RDS::DBParameterGroup
        ##
        class RDSDBParameterGroup < Resource
          include Model::Mixin::Taggable

          def initialize(*args)
            super
            type 'AWS::RDS::DBParameterGroup'
          end

          def description(value)
            property('Description', value)
          end

          def family(value)
            property('Family', value)
          end

          def parameters(value)
            property('Parameters', value)
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
      def parameter_group(name, &block)
        r = Model::Template::Resource::RDSDBParameterGroup.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
