require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::SecurityGroup
        ##
        class EC2SecurityGroupIngres < Resource
          extend Mixin::Protocol

          type 'AWS::EC2::SecurityGroupIngress'
          property :address, 'CidrIp'
          property :parent, 'GroupId'
          property :from, 'FromPort'
          property :to, 'ToPort'
          protocol_property :protocol, 'IpProtocol'
          property :source_group, 'SourceSecurityGroupId'
          property :source_owner, 'SourceSecurityGroupOwnerId'
        end
      end
    end
  end
end
