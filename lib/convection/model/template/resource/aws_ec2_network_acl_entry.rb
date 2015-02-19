require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::NetworkACL
        ##
        class EC2NetworkACLEntry < Resource
          include Model::Mixin::CIDRBlock
          extend Model::Mixin::Protocol

          property :acl, 'NetworkAclId'
          property :action, 'RuleAction'
          property :number, 'RuleNumber'
          property :egress, 'Egress'
          property :icmp, 'Icmp'
          property :range, 'PortRange'
          protocol_property

          def initialize(*args)
            super
            type 'AWS::EC2::NetworkAclEntry'
          end

          def render(*args)
            super.tap do |resource|
              resource['Properties']['Protocol'] = protocol # From protocol_property
            end
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_network_acl(name, &block)
        r = Model::Template::Resource::EC2NetworkACL.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
