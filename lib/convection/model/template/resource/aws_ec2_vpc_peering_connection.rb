require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::VPCPeeringConnection
        ##
        class EC2VPCPeeringConnection < Resource
          include Model::Mixin::Taggable

          type 'AWS::EC2::VPCPeeringConnection'
          property :vpc, 'VpcId'
          property :peer_vpc, 'PeerVpcId'

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
