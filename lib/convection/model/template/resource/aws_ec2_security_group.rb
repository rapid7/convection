require_relative '../resource'

module Convection
  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_security_group(name, &block)
        r = Model::Template::Resource::EC2SecurityGroup.new
        r.instance_exec(&block) if block

        resources[name] = r
      end

      module Resource
        ##
        # DSL For EC2SecurityGroup rules
        ##
        module EC2SecurityGroup
          def ingress_rule(&block)
            r = Model::Template::Resource::EC2SecurityGroup::Rule.new
            r.instance_exec(&block) if block

            security_group_ingress << r
          end

          def egress_rule(&block)
            r = Model::Template::Resource::EC2SecurityGroup::Rule.new
            r.instance_exec(&block) if block

            security_group_egress << r
          end
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::SecurityGroup
        ##
        class EC2SecurityGroup < Resource
          include DSL::Template::Resource::EC2SecurityGroup
          include Model::Mixin::Taggable

          attr_reader :security_group_ingress
          attr_reader :security_group_egress

          ##
          # Ingress/Egress Rule
          #
          class Rule < Resource
            attribute :from
            attribute :to
            attribute :protocol

            attribute :cidr_ip
            attribute :destination_group
            attribute :source_group
            attribute :source_group_owner

            def render
              {
                'IpProtocol' => protocol,
                'FromPort' => from,
                'ToPort' => to
              }.tap do |rule|
                rule['CidrIp'] = cidr_ip unless cidr_ip.nil?
                rule['DestinationSecurityGroupId'] = destination_group unless destination_group.nil?
                rule['SourceSecurityGroupId'] = source_group unless source_group.nil?
                rule['SourceSecurityGroupOwnerId'] = source_group_owner unless source_group.nil?
              end
            end
          end

          def initialize(*args)
            super

            type 'AWS::EC2::SecurityGroup'
            @security_group_ingress = []
            @security_group_egress = []
          end

          def description(value)
            property('GroupDescription', value)
          end

          def vpc_id(value)
            property('VpcId', value)
          end

          def render(*args)
            super.tap do |resource|
              resource['Properties']['SecurityGroupIngress'] = security_group_ingress.map(&:render)
              resource['Properties']['SecurityGroupEgress'] = security_group_egress.map(&:render)
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
