require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Route
        ##
        class EC2Route < Resource
          property :route_table_id, 'RouteTableId'
          property :destination, 'DestinationCidrBlock'
          property :gateway, 'GatewayId'
          property :instance, 'InstanceId'
          property :interface, 'NetworkInterfaceId'
          property :peer, 'VpcPeeringConnectionId'

          def initialize(*args)
            super
            type 'AWS::EC2::Route'
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_route(name, &block)
        r = Model::Template::Resource::EC2Route.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
