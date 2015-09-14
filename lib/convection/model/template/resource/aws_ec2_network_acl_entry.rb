require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::NetworkACL
        ##
        class EC2NetworkACLEntry < Resource
          extend Mixin::CIDRBlock
          extend Mixin::Protocol

          type 'AWS::EC2::NetworkAclEntry'
          property :acl, 'NetworkAclId'
          property :action, 'RuleAction'
          property :number, 'RuleNumber'
          property :egress, 'Egress'
          property :icmp, 'Icmp'
          property :range, 'PortRange'
          cidr_property :network, 'CidrBlock'
          protocol_property :protocol, 'Protocol'
        end
      end
    end
  end
end
