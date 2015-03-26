require_relative '../../dsl/intrinsic_functions'
require_relative '../mixin/cidr_block'
require_relative '../mixin/conditional'
require_relative '../mixin/protocol'
require_relative '../mixin/taggable'
require_relative './output'

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
          def property(accesor, name, type = :string)
            case type.to_sym
            when :string
              define_method(accesor) do |value = nil|
                ## Call Instance#property
                return property(name) if value.nil?
                property(name, value)
              end
            when :array
              define_method(accesor) do |*value|
                @properties[name] = [] unless @properties[name].is_a?(Array)
                @properties[name].push(*value)
              end
            else
              fail TypeError, "Property must be defined with type `string` or `array`, not #{ type }"
            end
          end
        end

        attribute :type
        attr_reader :name
        attr_reader :properties

        def initialize(name, template)
          @name = name
          @template = template

          @type = ''
          @properties = {}
          @depends_on = []
        end

        def stack
          @template.stack
        end

        def property(key, value = nil)
          return properties[key] if value.nil?
          properties[key] = value.is_a?(Model::Template::Resource) ? value.reference : value
        end

        def depends_on(resource)
          @depends_on << resource
        end

        def reference
          {
            'Ref' => name
          }
        end

        def with_output(output_name = name, value = reference, &block)
          o = Model::Template::Output.new(output_name, @template)
          o.value = value

          o.instance_exec(&block) if block
          @template.outputs[name] = o
        end

        def render
          {
            'Type' => type,
            'Properties' => properties
          }.tap do |resource|
            resource['DependsOn'] = @depends_on unless @depends_on.empty?
            render_condition(resource)
          end
        end
      end
    end
  end
end

require_relative 'resource/aws_auto_scaling_auto_scaling_group.rb'
require_relative 'resource/aws_cloud_watch_alarm'
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
require_relative 'resource/aws_elb.rb'
require_relative 'resource/aws_s3_bucket'
require_relative 'resource/aws_s3_bucket_policy'
require_relative 'resource/aws_iam_group'
require_relative 'resource/aws_iam_access_key'
require_relative 'resource/aws_iam_role'
require_relative 'resource/aws_iam_policy'
require_relative 'resource/aws_iam_user'
require_relative 'resource/aws_iam_instance_profile'
require_relative 'resource/aws_rds_db_instance'
require_relative 'resource/aws_rds_db_parameter_group'
require_relative 'resource/aws_rds_db_subnet_group.rb'
require_relative 'resource/aws_rds_db_security_group.rb'
require_relative 'resource/aws_route53_recordset.rb'
require_relative 'resource/aws_sns_topic'
require_relative 'resource/aws_sqs_queue'
require_relative 'resource/aws_sqs_queue_policy'
