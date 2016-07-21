require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::DHCPOptions
        ##
        class DHCPOptions < Resource
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