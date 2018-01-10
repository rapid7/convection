require_relative '../resource'

module Convection
  module DSL
    module Template
      module Resource
        ##
        # DSL For EC2SecurityGroup rules
        ##
        module EC2SecurityGroup
          def ingress_rule(protocol = nil, port = nil, source = nil, &block)
            rule = Model::Template::Resource::EC2SecurityGroup::Rule.new("#{ name }IngressGroupRule", @template)
            rule.protocol = protocol unless protocol.nil?
            rule.from = port unless port.nil?
            rule.to = port unless port.nil?
            rule.source = source unless source.nil?

            rule.instance_exec(&block) if block
            security_group_ingress << rule
          end

          def egress_rule(protocol = nil, port = nil, destination = nil, &block)
            rule = Model::Template::Resource::EC2SecurityGroup::Rule.new("#{ name }EgressGroupRule", @template)
            rule.protocol = protocol unless protocol.nil?
            rule.from = port unless port.nil?
            rule.to = port unless port.nil?
            rule.destination = destination unless destination.nil?

            rule.instance_exec(&block) if block
            security_group_egress << rule
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
        #
        # @example
        #   ec2_security_group 'SuperSecretSecurityGroup' do
        #     description 'This is a super secure group that nobody should know about.'
        #     vpc 'vpc-deadb33f'
        #   end
        ##
        class EC2SecurityGroup < Resource
          include DSL::Template::Resource::EC2SecurityGroup
          include Model::Mixin::Taggable

          attr_reader :security_group_ingress
          attr_reader :security_group_egress

          # @example Egress rule
          #   ec2_security_group 'SuperSecretSecurityGroup' do
          #     # other properties...
          #
          #     egress_rule :tcp, 443 do
          #       # The source CIDR block.
          #       destination '10.10.10.0/24'
          #     end
          #   end
          #
          # @example Ingress rule
          #   ec2_security_group 'SuperSecretSecurityGroup' do
          #     # other properties...
          #
          #     ingress_rule :tcp, 8080 do
          #       # The source security group ID.
          #       source_group stack.get('security-groups', 'HttpProxy')
          #     end
          #   end
          class Rule < Resource
            attribute :from
            attribute :to
            attribute :protocol

            attribute :source
            attribute :destination
            attribute :destination_group
            attribute :source_group
            attribute :source_group_owner

            def render
              {
                'IpProtocol' => Mixin::Protocol.lookup(protocol)
              }.tap do |rule|
                rule['FromPort'] = from unless from.nil?
                rule['ToPort'] = to unless to.nil?
                rule['CidrIp'] = source unless source.nil?
                rule['CidrIp'] = destination unless destination.nil?
                rule['DestinationSecurityGroupId'] = destination_group unless destination_group.nil?
                rule['SourceSecurityGroupId'] = source_group unless source_group.nil?
                rule['SourceSecurityGroupOwnerId'] = source_group_owner unless source_group_owner.nil?
              end
            end
          end

          type 'AWS::EC2::SecurityGroup'
          property :description, 'GroupDescription'
          property :vpc, 'VpcId'

          def initialize(*args)
            super

            @security_group_ingress = []
            @security_group_egress = []
          end

          def render(*args)
            super.tap do |resource|
              resource['Properties']['SecurityGroupIngress'] = security_group_ingress.map(&:render)
              resource['Properties']['SecurityGroupEgress'] = security_group_egress.map(&:render)
              render_tags(resource)
            end
          end

          def to_hcl_json(*)
            tf_sg_name = name.underscore
            tf_sg_var_id = "${aws_security_group.#{tf_sg_name}.id}"
            tf_resources = []

            # Define the security group resource.
            tf_resources << {
              aws_security_group: {
                tf_sg_name => {
                  vpc_id: vpc,
                  description: description,
                  tags: tags.reject { |_, v| v.nil? }
                }.reject { |_, v| v.nil? }
              }
            }

            tf_sg_rules = {}

            # Define helper functions to map Convection rules to Terraform ones.
            sg_rule_to_tf = lambda do |rule_type, item, index|
              tf_sg_rule_name = "#{tf_sg_name}_#{rule_type}_#{index}"

              tf_sg_rules[tf_sg_rule_name] = {
                type: rule_type,
                security_group_id: tf_sg_var_id,
                from_port: item.from,
                to_port: item.to,
                protocol: item.protocol,
                cidr_block: item.source,
                # TODO: Missing attribs & checks. Should probably be defined as a
                #       seperate function to reuse for egress.
              }.reject { |_, v| v.nil? }
            end

            # Map the contained rules to TF.
            security_group_ingress.each_with_index { |item, obj| sg_rule_to_tf.call('ingress', item, obj) }
            security_group_egress.each_with_index { |item, obj| sg_rule_to_tf.call('egress', item, obj) }

            tf_resources << { aws_security_group_rule: tf_sg_rules }

            # Return the JSON representation of this resource.
            { resource: tf_resources }.to_json
          end

          def terraform_import_commands(module_path: 'root')
            prefix = "#{module_path}." unless module_path == 'root'
            resource_id = stack.resources[name] && stack.resources[name].physical_resource_id
            commands = ['# Import the security group:']
            commands << "terraform import #{prefix}aws_security_group.#{name.underscore} #{resource_id}"
            commands
          end
        end
      end
    end
  end
end
