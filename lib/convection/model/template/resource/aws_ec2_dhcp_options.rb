require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::DHCPOptions
        #
        # @example
        #   ec2_dhcp_options 'TestOptions' do
        #     domain_name 'example.com'
        #     domain_name_servers  '10.0.0.1', '10.0.0.2'
        #     netbios_name_servers '10.0.0.1', '10.0.0.2'
        #     netbios_node_type 1
        #     ntp_servers '10.0.0.1', '10.0.0.2'
        #     tag 'Name', 'Test'
        #   end
        ##
        class EC2DHCPOptions < Resource
          include Model::Mixin::Taggable
          type 'AWS::EC2::DHCPOptions'
          property :domain_name, 'DomainName'
          property :domain_name_servers, 'DomainNameServers', :type => :list
          property :netbios_name_servers, 'NetbiosNameServers', :type => :list
          property :netbios_node_type, 'NetbiosNodeType'
          property :ntp_servers, 'NtpServers', :type => :list

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
