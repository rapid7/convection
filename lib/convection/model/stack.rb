require 'aws-sdk'
require 'json'

module Convection
  module Model
    ##
    # Instantiation of a template in an account/region
    ##
    class Stack
      attr_reader :name
      attr_accessor :template

      attr_accessor :region
      attr_accessor :credentials
      attr_reader :parameters
      attr_reader :tags
      attr_accessor :on_failure
      attr_reader :capabilities
      attr_reader :options

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
        @template = template

        @region = options.delete(:region) { |_| 'us-east-1' }
        @credentials = options.delete(:credentials)
        @parameters = options.delete(:parameters) { |_| {} } # Default empty hash
        @tags = options.delete(:tags) { |_| {} } # Default empty hash

        ## There can be only one...
        @on_failure = options.delete(:on_failure) { |_| 'DELETE' }
        options.delete(:disable_rollback)

        @capabilities = options.delete(:capabilities) { |_| ['CAPABILITY_IAM'] }
        @options = options

        @ec2_client = AWS::EC2::Client.new(:region => region,
                                           :credentials => @credentials)
        @cf_client = AWS::CloudFormation::Client.new(:region => region,
                                                     :credentials => @credentials)
      end

      def stacks
        @stacks || cf_get_stacks
      end

      def status
        stacks[name].stack_status rescue NOT_CREATED
      end

      def exist?
        stacks.include?(name)
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

      def render
        template.render(self)
      end

      def to_json
        template.to_json(self)
      end

      def apply
        cf_get_stacks ## force-update status
        request_options = @options.clone.tap do |o|
          o[:stack_name] = name
          o[:template_body] = to_json
          o[:parameters] = cf_parameters
          o[:capabilities] = capabilities
        end

        return @cf_client.update_stack(request_options) if exist?
        @cf_client.create_stack(request_options.tap do |o|
          o[:tags] = cf_tags
          o[:on_failure] = @on_failure
        end)
      rescue AWS::CloudFormation::Errors::ValidationError => e
        ## TODO Return something sane
        ## SDK throws this as an error >.<
        raise e unless e.message == 'No updates are to be performed.'
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
        {}.tap do |col|
          cf_stacks = @cf_client.list_stacks.stack_summaries rescue []
          cf_stacks.each do |s|
            next if s.stack_status == DELETE_COMPLETE
            col[s.stack_name] = s
          end
        end
      end

      def cf_parameters
        parameters.map do |p|
          {
            :parameter_key => p[0].to_s,
            :parameter_value => p[1].to_s,
            :use_previous_value => false
          }
        end
      end

      def cf_tags
        tags.map do |p|
          {
            :key => p[0].to_s,
            :value => p[1].to_s
          }
        end
      end
    end
  end
end
