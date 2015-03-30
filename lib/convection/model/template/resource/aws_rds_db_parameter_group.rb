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

          property :description, 'Description'
          property :family, 'Family'

          def initialize(*args)
            super
            type 'AWS::RDS::DBParameterGroup'
            @properties['Parameters'] = {}
          end

          def parameter(key, value)
            @properties['Parameters'][key] = value
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
      def rds_parameter_group(name, &block)
        r = Model::Template::Resource::RDSDBParameterGroup.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
