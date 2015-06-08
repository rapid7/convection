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

          type 'AWS::RDS::DBParameterGroup', :rds_parameter_group
          property :description, 'Description'
          property :family, 'Family'
          property :parameter, 'Parameters', :type => :hash

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
