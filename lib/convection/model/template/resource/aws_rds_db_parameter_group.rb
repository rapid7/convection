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

          type 'AWS::RDS::DBParameterGroup'
          property :description, 'Description'
          property :family, 'Family'

          def initialize(*args)
            super
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
end
