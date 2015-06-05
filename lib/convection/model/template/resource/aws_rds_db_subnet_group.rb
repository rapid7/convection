require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::RDS::DBSubnetGroup
        ##
        class RDSDBSubnetGroup < Resource
          include Model::Mixin::Taggable

          type 'AWS::RDS::DBSubnetGroup'
          property :subnet, 'SubnetIds', :type => :list
          property :description, 'DBSubnetGroupDescription'

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
