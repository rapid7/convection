require_relative '../lib/convection'

module Convection
  module Demo
    VPC = Convection.template do
      description 'Demo VPC'

      ## Define the VPC
      ec2_vpc 'TargetVPC' do
        network stack['subnet']
        subnet_length 24
        enable_dns true

        tag 'Name', stack.cloud
        tag 'Stack', stack.cloud
        with_output 'id'

        #
        # PUBLIC SUBNETS
        #

        ## Add an InternetGateway
        add_internet_gateway

        public_acl = add_network_acl 'Public' do
          entry 'AllowAllIngress' do
            action 'allow'
            number 100
            network '0.0.0.0/0'
            protocol :any
            range :From => 0,
                  :To => 65_535
          end

          entry 'AllowAllEgress' do
            action 'allow'
            number 100
            egress true
            network '0.0.0.0/0'
            protocol :any
            range :From => 0,
                  :To => 65_535
          end

          tag 'Name', "acl-public-#{ stack.cloud }"
          tag 'Stack', stack.cloud
        end

        public_table = add_route_table 'Public', :gateway_route => true do
          tag 'Name', "routes-public-#{ stack.cloud }"
          tag 'Stack', stack.cloud
        end

        stack.availability_zones do |zone, i|
          add_subnet "Public#{ i }" do
            availability_zone zone
            acl public_acl
            route_table public_table

            with_output

            immutable_metadata "public-#{ stack.cloud }"
            tag 'Name', "subnet-public-#{ stack.cloud }-#{ zone }"
            tag 'Stack', stack.cloud
            tag 'Service', 'Public'
          end
        end


        #
        # PRIVATE SUBNETS
        # These subnets don't support a public IP, but can access the internet
        # via a NAT Gateway
        #

        private_acl = add_network_acl('Private') do
          entry 'AllowAllIngress' do
            action 'allow'
            number 100
            network '0.0.0.0/0'
            protocol :any
            range :From => 0,
                  :To => 65_535
          end

          entry 'AllowAllEgress' do
            action 'allow'
            number 100
            egress true
            network '0.0.0.0/0'
            protocol :any
            range :From => 0,
                  :To => 65_535
          end

          tag 'Name', "acl-private-#{ stack.cloud }"
          tag 'Stack', stack.cloud
        end

        private_table = add_route_table('Private', :gateway_route => false) do
          tag 'Name', "routes-private-#{ stack.cloud }"
          tag 'Stack', stack.cloud
        end

        stack.availability_zones do |zone, i|
          add_subnet "Private#{ i }" do
            availability_zone zone
            acl private_acl
            route_table private_table

            with_output

            immutable_metadata "private-#{ stack.cloud }"
            tag 'Name', "subnet-public-#{ stack.cloud }-#{ zone }"
            tag 'Stack', stack.cloud
            tag 'Service', 'Private'
          end
        end

        ## Add a NAT Gateway
        stack.availability_zones do |zone, i|
          ec2_eip "NatGatewayIP#{i}" do
            domain 'vpc'
          end

          ec2_nat_gateway "NatGateway#{i}" do
            subnet fn_ref("TargetVPCSubnetPublic#{i}")
            allocation_id get_att("NatGatewayIP#{i}", 'AllocationId')
          end

          ec2_route "NatGatewayRoute#{i}" do
            destination '0.0.0.0/0'
            nat_gateway fn_ref("NatGateway#{i}")
            route_table_id private_table
          end

          # Create a NAT Gateway in only one AZ to save $$$
          break
        end
      end
    end
  end
end
