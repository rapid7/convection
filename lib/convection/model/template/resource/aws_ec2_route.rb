require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Route
        ##
        class EC2Route < Resource
          type 'AWS::EC2::Route'
          property :route_table_id, 'RouteTableId'
          property :destination, 'DestinationCidrBlock'
          property :gateway, 'GatewayId'
          property :nat_gateway, 'NatGatewayId'
          property :instance, 'InstanceId'
          property :interface, 'NetworkInterfaceId'
          property :peer, 'VpcPeeringConnectionId'

          def to_hcl_json(*)
            tf_record_attrs = {
              route_table_id: route_table_id,
              destination_cidr_block: destination,
              vpc_peering_connection_id: peer,
              gateway_id: gateway,
              nat_gateway_id: nat_gateway,
              instance_id: instance,
              network_interface_id: interface
            }

            tf_record_attrs.reject! { |_, v| v.nil? }

            tf_record = {
              aws_route: {
                name.underscore => tf_record_attrs
              }
            }

            { resource: tf_record }.to_json
          end

          def terraform_import_commands(module_path: 'root')
            ['# Route import is not supported by Terraform.']
          end
        end
      end
    end
  end
end
