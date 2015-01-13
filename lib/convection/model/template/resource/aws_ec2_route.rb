require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Route
        ##
        class EC2Route < Resource
          def initialize(*args)
            super
            type 'AWS::EC2::Route'
          end

          def route_table_id(value)
            property('RouteTableId', value)
          end

          def destination(value)
            property('DestinationCidrBlock', value)
          end

          def gateway(value)
            property('GatewayId', value)
          end

          def instance(value)
            property('InstanceId', value)
          end

          def interface(value)
            property('NetworkInterfaceId', value)
          end

          def peer(value)
            property('VpcPeeringConnectionId', value)
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
