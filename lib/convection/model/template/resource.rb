require_relative '../../dsl/intrinsic_functions'
require_relative '../mixin/cidr_block'
require_relative '../mixin/conditional'
require_relative '../mixin/protocol'
require_relative '../mixin/taggable'

module Convection
  module Model
    class Template
      ##
      # Resource
      ##
      class Resource
        extend DSL::Helpers
        include DSL::IntrinsicFunctions
        include Model::Mixin::Conditional

        class << self
          ## Class::property - Helper for adding property accessors
          def property(accesor, name)
            define_method(accesor) do |value|
              property(name, value) ## Call Instance#property
            end
          end
        end

        attribute :type
        attribute :depends_on
        attr_reader :name
        attr_reader :properties

        def initialize(name, template)
          @name = name
          @template = template

          @type = ''
          @properties = {}
          @depends_on = ''
        end

        def stack
          @template.stack
        end

        def property(key, value)
          properties[key] = value.is_a?(Model::Template::Resource) ? value.reference : value
        end

        def reference
          {
            'Ref' => name
          }
        end

        def render
          resource = {
            'Type' => type,
            'Properties' => properties,
          }
          resource.merge!({'DependsOn' => depends_on}) unless depends_on.empty?
          resource.tap do |resource|
            render_condition(resource)
          end
        end
      end
    end
  end
end

require_relative 'resource/aws_ec2_instance'
require_relative 'resource/aws_ec2_internet_gateway'
require_relative 'resource/aws_ec2_network_acl'
require_relative 'resource/aws_ec2_network_acl_entry'
require_relative 'resource/aws_ec2_route'
require_relative 'resource/aws_ec2_route_table'
require_relative 'resource/aws_ec2_security_group'
require_relative 'resource/aws_ec2_subnet'
require_relative 'resource/aws_ec2_subnet_network_acl_association'
require_relative 'resource/aws_ec2_subnet_route_table_association'
require_relative 'resource/aws_ec2_vpc'
require_relative 'resource/aws_ec2_vpc_gateway_attachment'
require_relative 'resource/aws_s3_bucket'
require_relative 'resource/aws_s3_bucket_policy'
require_relative 'resource/aws_iam_role'
require_relative 'resource/aws_iam_policy'
require_relative 'resource/aws_rds_db_instance'
require_relative 'resource/aws_rds_db_parameter_group'
require_relative 'resource/aws_rds_db_subnet_group.rb'
require_relative 'resource/aws_rds_db_security_group.rb'
