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
      end
    end
  end
end
