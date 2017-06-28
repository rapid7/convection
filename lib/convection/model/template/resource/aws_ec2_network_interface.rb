require_relative '../resource'

module Convection
  module DSL
    module Template
      module Resource
        ##
        # Add DSL helpers to EC2NetworkACL
        ##
        module EC2NetworkInterface
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::NetworkACL
        ##
        class EC2NetworkInterface < Resource
          include DSL::Template::Resource::EC2NetworkInterface
          include Model::Mixin::Taggable

          type 'AWS::EC2::NetworkInterface'
          property :description, 'Description'
          property :group_set, 'GroupSet', :type => :list
          alias_method :security_group, :group_set
          property :private_ip_address, 'PrivateIpAddress'
          property :private_ip_addresses, 'PrivateIpAddresses', :type => :list
          property :secondary_private_ip_address_count, 'SecondaryPrivateIpAddressCount'
          property :source_dest_check, 'SourceDestCheck'
          property :subnet, 'SubnetId'

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
