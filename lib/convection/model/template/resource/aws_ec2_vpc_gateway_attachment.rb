require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::VPCGatewayAttachment
        ##
        class EC2VPCGatewayAttachment < Resource
          def initialize(*args)
            super
            type 'AWS::EC2::VPCGatewayAttachment'
          end

          def vpc_id(value)
            property('VpcId', value)
          end

          def internet_gateway(value)
            property('InternetGatewayId', value)
          end

          def vpn_gateway(value)
            property('VpnGatewayId', value)
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_vpc_gateway_attachment(name, &block)
        r = Model::Template::Resource::EC2VPCGatewayAttachment.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
