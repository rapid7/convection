require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::VPNGateway
        ##
        class EC2VPNGateway < Resource
          include Model::Mixin::Taggable

          type 'AWS::EC2::VPNGateway'
          property :conn_type, 'Type'

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
