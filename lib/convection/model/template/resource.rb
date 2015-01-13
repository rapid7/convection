require_relative '../../dsl/intrinsic_functions'
require_relative '../mixin/cidr_block'
require_relative '../mixin/conditional'
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

        attribute :type
        attr_reader :name
        attr_reader :properties

        def initialize(name, template)
          @name = name
          @template = template

          @type = ''
          @properties = {}
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
          {
            'Type' => type,
            'Properties' => properties
          }.tap do |resource|
            render_condition(resource)
          end
        end
      end
    end
  end
end

require_relative 'resource/aws_ec2_instance'
require_relative 'resource/aws_ec2_internet_gateway'
require_relative 'resource/aws_ec2_route'
require_relative 'resource/aws_ec2_route_table'
require_relative 'resource/aws_ec2_security_group'
require_relative 'resource/aws_ec2_subnet'
require_relative 'resource/aws_ec2_subnet_route_table_association'
require_relative 'resource/aws_ec2_vpc'
require_relative 'resource/aws_ec2_vpc_gateway_attachment'
