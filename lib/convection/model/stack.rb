require 'aws-sdk'
require 'json'

module Convection
  module Model
    ##
    # Instantiation of a template in an account/region
    ##
    class Stack
      attr_reader :name
      attr_reader :parameters
      attr_reader :tags

      attr_reader :region
      attr_accessor :template

      ## Valid Stack Statuses
      CREATE_IN_PROGRESS = 'CREATE_IN_PROGRESS'
      CREATE_FAILED = 'CREATE_FAILED'
      CREATE_COMPLETE = 'CREATE_COMPLETE'
      ROLLBACK_IN_PROGRESS = 'ROLLBACK_IN_PROGRESS'
      ROLLBACK_FAILED = 'ROLLBACK_FAILED'
      ROLLBACK_COMPLETE = 'ROLLBACK_COMPLETE'
      DELETE_IN_PROGRESS = 'DELETE_IN_PROGRESS'
      DELETE_FAILED = 'DELETE_FAILED'
      DELETE_COMPLETE = 'DELETE_COMPLETE'
      UPDATE_IN_PROGRESS = 'UPDATE_IN_PROGRESS'
      UPDATE_COMPLETE_CLEANUP_IN_PROGRESS = 'UPDATE_COMPLETE_CLEANUP_IN_PROGRESS'
      UPDATE_COMPLETE = 'UPDATE_COMPLETE'
      UPDATE_ROLLBACK_IN_PROGRESS = 'UPDATE_ROLLBACK_IN_PROGRESS'
      UPDATE_ROLLBACK_FAILED = 'UPDATE_ROLLBACK_FAILED'
      UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS = 'UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS'
      UPDATE_ROLLBACK_COMPLETE = 'UPDATE_ROLLBACK_COMPLETE'

      ## Internal status
      NOT_CREATED = 'NOT_CREATED'

      def initialize(name, template, options = {})
        @name = name
        @parameters = options[:parameters] || {}
        @tags = options[:tags] || {}

        @template = template
        @region = options[:region] || 'us-east-1'
        @credentials = options[:credentials]

        @ec2_client = AWS::EC2::Client.new(:region => region,
                                           :credentials => @credentials)
        @cf_client = AWS::CloudFormation::Client.new(:region => region,
                                                     :credentials => @credentials)
      end

      def stacks
        return cf_get_stacks if @stacks.nil?

        @stacks
      end

      def status
        stacks[name].stack_status rescue NOT_CREATED
      end

      def exist?
        stacks.include?(name) && !deleted?
      end

      def complete?
        [CREATE_COMPLETE, UPDATE_COMPLETE].include?(status)
      end

      def rollback?
        [ROLLBACK_IN_PROGRESS, ROLLBACK_FAILED, ROLLBACK_COMPLETE,
         UPDATE_ROLLBACK_IN_PROGRESS, UPDATE_ROLLBACK_FAILED,
         UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS,
         UPDATE_ROLLBACK_COMPLETE].include?(status)
      end

      def deleted?
        status == DELETE_COMPLETE
      end

      def render
        template.render(self)
      end

      def apply
        cf_get_stacks ## force-update status

        if exist?
          @cf_client.update_stack(
            :stack_name => name,
            :template_body => JSON.pretty_generate(render),
            :parameters => cf_parameters,
            :tags => cf_tags
          )
        else
          @cf_client.create_stack(
            :stack_name => name,
            :template_body => JSON.pretty_generate(render),
            :parameters => cf_parameters
          )
        end
      end

      def delete
        @cf_client.delete_stack(
          :stack_name => name
        )
      end

      def availability_zones(&block)
        @availability_zones ||=
          @ec2_client.describe_availability_zones.availability_zone_info.map(&:zone_name).sort

        @availability_zones.each_with_index(&block) if block
        @availability_zones
      end

      private

      def cf_get_stacks
        @stacks ||= {}.tap do |stacks_|
          stacks__ = @cf_client.list_stacks.stack_summaries rescue []
          stacks__.each do |s|
            stacks_[s.stack_name] = s
          end
        end
      end

      def cf_parameters
        parameters.map do |p|
          {
            'parameter_key' => p[0],
            'parameter_value' => p[1],
            'use_previous_value' => false
          }
        end
      end

      def cf_tags
        tags.map do |p|
          {
            'key' => p[0],
            'value' => p[1]
          }
        end
      end
    end
  end
end
