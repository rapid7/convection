require 'aws-sdk'
require 'json'

module Convection
  module Model
    ##
    # Instantiation of a template in an account/region
    ##
    class Stack
      attr_reader :name
      attr_reader :region
      attr_accessor :template

      def initialize(name, template, options = {})
        @name = name
        @template = template
        @region = options[:region] || 'us-east-1'
        @credentials = options[:credentials]

        @ec2_client = AWS::EC2::Client.new(:region => region,
                                           :credentials => @credentials)
        @cf_client = AWS::CloudFormation::Client.new(:region => region,
                                                     :credentials => @credentials)
      end

      def stacks
        @stacks ||= {}.tap do |stacks|
          @cf_client.list_stacks.stack_summaries.each do |s|
            stacks[s.stack_name] = s
          end
        end
      end

      def exists?
        stacks.include?(name)
      end

      def status
        stacks[name].stack_status rescue nil
      end

      def render
        template.render(self)
      end

      def apply
        @cf_client.create_stack(
          :stack_name => name,
          :template_body => JSON.pretty_generate(render),
          :parameters => []
        )
      end

      def delete
      end

      def availability_zones
        @availability_zones ||=
          @ec2_client.describe_availability_zones.availability_zone_info.map(&:zone_name)
      end
    end
  end

  module DSL
    ##
    # DSL Helpers for Stack
    ##
    module Stack
      def availability_zones(&block)
        stack.availability_zones.each_with_index(&block) if block
        stack.availability_zones
      end
    end
  end
end
