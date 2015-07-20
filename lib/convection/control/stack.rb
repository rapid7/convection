require 'aws-sdk'
require 'json'

module Convection
  module Control
    ##
    # Instantiation of a template in an account/region
    ##
    class Stack
      attr_reader :id
      attr_reader :name
      attr_accessor :template

      attr_reader :attributes
      attr_reader :errors
      attr_reader :options
      attr_reader :resources
      attr_reader :outputs

      ## AWS-SDK
      attr_accessor :region
      attr_accessor :cloud
      attr_reader :capabilities
      attr_accessor :credentials
      attr_reader :parameters
      attr_reader :tags
      attr_accessor :on_failure

      ## Valid Stack Statuses
      CREATE_COMPLETE = 'CREATE_COMPLETE'
      CREATE_FAILED = 'CREATE_FAILED'
      CREATE_IN_PROGRESS = 'CREATE_IN_PROGRESS'
      DELETE_COMPLETE = 'DELETE_COMPLETE'
      DELETE_FAILED = 'DELETE_FAILED'
      DELETE_IN_PROGRESS = 'DELETE_IN_PROGRESS'
      ROLLBACK_COMPLETE = 'ROLLBACK_COMPLETE'
      ROLLBACK_FAILED = 'ROLLBACK_FAILED'
      ROLLBACK_IN_PROGRESS = 'ROLLBACK_IN_PROGRESS'
      UPDATE_COMPLETE = 'UPDATE_COMPLETE'
      UPDATE_COMPLETE_CLEANUP_IN_PROGRESS = 'UPDATE_COMPLETE_CLEANUP_IN_PROGRESS'
      UPDATE_FAILED = 'UPDATE_FAILED'
      UPDATE_IN_PROGRESS = 'UPDATE_IN_PROGRESS'
      UPDATE_ROLLBACK_COMPLETE = 'UPDATE_ROLLBACK_COMPLETE'
      UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS = 'UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS'
      UPDATE_ROLLBACK_FAILED = 'UPDATE_ROLLBACK_FAILED'
      UPDATE_ROLLBACK_IN_PROGRESS = 'UPDATE_ROLLBACK_IN_PROGRESS'

      ## Internal status
      NOT_CREATED = 'NOT_CREATED'

      def initialize(name, template, options = {})
        @name = name
        @template = template.clone(self)
        @errors = []

        @cloud = options.delete(:cloud)
        @cloud_name = options.delete(:cloud_name)

        @region = options.delete(:region) { |_| 'us-east-1' }
        @credentials = options.delete(:credentials)
        @parameters = options.delete(:parameters) { |_| {} } # Default empty hash
        @tags = options.delete(:tags) { |_| {} } # Default empty hash
        @on_failure = options.delete(:on_failure) { |_| 'DELETE' }
        options.delete(:disable_rollback) # There can be only one...
        @capabilities = options.delete(:capabilities) { |_| ['CAPABILITY_IAM'] }

        @attributes = options.delete(:attributes) { |_| Model::Attributes.new }
        @options = options

        client_options = {}.tap do |opt|
          opt[:region] = @region
          opt[:credentials] = @credentials unless @credentials.nil?
        end
        @ec2_client = Aws::EC2::Client.new(client_options)
        @cf_client = Aws::CloudFormation::Client.new(client_options)

        ## Get initial state
        render
        cf_get_stack(cloud_name)

        ## Get last-seen event ID
        @last_event_seen = nil
        cf_get_events(1) unless @id.nil?
      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      def cloud_name
        return @cloud_name unless @cloud_name.nil?
        return name if cloud.nil?
        "#{ cloud }-#{ name }"
      end

      def include?(stack, key = nil)
        return @attributes.include?(name, stack) if key.nil?
        @attributes.include?(stack, key)
      end

      def [](key)
        @attributes.get(name, key)
      end

      def []=(key, value)
        @attributes.set(name, key, value)
      end

      def get(*args)
        @attributes.get(*args, "** Warning: Could not resolve value [#{args[1]}] for stack [#{args[0]}] **")
      end

      def status
        @remote.stack_status rescue NOT_CREATED
      end

      def exist?
        !@remote.nil?
      end

      def in_progress?
        [CREATE_IN_PROGRESS, ROLLBACK_IN_PROGRESS, DELETE_IN_PROGRESS,
         UPDATE_IN_PROGRESS, UPDATE_COMPLETE_CLEANUP_IN_PROGRESS,
         UPDATE_ROLLBACK_IN_PROGRESS,
         UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS
        ].include?(status)
      end

      def complete?
        [CREATE_COMPLETE, ROLLBACK_COMPLETE, UPDATE_COMPLETE, UPDATE_ROLLBACK_COMPLETE].include?(status)
      end

      def fail?
        [CREATE_FAILED, ROLLBACK_FAILED, DELETE_FAILED, UPDATE_ROLLBACK_FAILED].include?(status)
      end

      def error?
        !errors.empty?
      end

      def success?
        !error? && complete?
      end

      def render
        template.render
      end

      def to_json(pretty = false)
        template.to_json(nil, pretty)
      end

      def apply(&block)
        request_options = @options.clone.tap do |o|
          o[:template_body] = to_json
          o[:parameters] = cf_parameters
          o[:capabilities] = capabilities
        end

        if exist?
          if diff.empty? ## No Changes. Just get resources and move on
            block.call(Model::Event.new(:complete, "Stack #{ name } has no changes", :info)) if block
            cf_get_stack
            return
          end

          ## Update
          @cf_client.update_stack(request_options.tap do |o|
            o[:stack_name] = id
          end)
        else
          ## Create
          @cf_client.create_stack(request_options.tap do |o|
            o[:stack_name] = cloud_name

            o[:tags] = cf_tags
            o[:on_failure] = on_failure
          end)

          cf_get_stack(cloud_name) # Get ID of new stack
        end

        watch(&block) if block # Block execution on stack status
      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      def diff
        @template.diff(cf_get_template)
      end

      def watch(poll = 2, &block)
        cf_get_stack

        loop do
          cf_get_events.reverse.each do |event|
            block.call(Model::Event.from_cf(event))
          end if block

          break unless in_progress?

          sleep poll
          cf_get_stack
        end
      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      def delete(&block)
        @cf_client.delete_stack(
          :stack_name => id
        )

        ## Block execution on stack status
        watch(&block) if block

        cf_get_stack
      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      def availability_zones(&block)
        @availability_zones ||=
          @ec2_client.describe_availability_zones.availability_zones.map(&:zone_name).sort

        @availability_zones.each_with_index(&block) if block
        @availability_zones
      end

      def validate
        result = @cf_client.validate_template(:template_body => template.to_json)
        raise result.context.http_response.inspect unless result.successful?
        puts "\nTemplate validated successfully"
      end

      private

      def cf_get_stack(stack_name = id)
        @remote = @cf_client.describe_stacks(:stack_name => stack_name).stacks.first
        @id = @remote.stack_id

        @resources = {}
        @cf_client.list_stack_resources(:stack_name => @id).each do |page|
          page.stack_resource_summaries.each do |resource|
            next unless @template.attribute_mappings.include?(resource[:logical_resource_id])

            attribute_map = @template.attribute_mappings[resource[:logical_resource_id]]
            case attribute_map[:type].to_sym
            when :string
              @resources[attribute_map[:name]] = resource[:physical_resource_id]
            when :array
              @resources[attribute_map[:name]] = [] unless @resources[attribute_map[:name]].is_a?(Array)
              @resources[attribute_map[:name]].push(resource[:physical_resource_id])
            else
              fail TypeError, "Attribute Mapping must be defined with type `string` or `array`, not #{ type }"
            end
          end
        end

        @outputs = Hash[@remote.outputs.map do |output|
          [output[:output_key].to_s, (JSON.parse(output[:output_value]) rescue output[:output_value])]
        end]

        ## Add outputs to attribute set
        @attributes.stack(self)

      rescue Aws::CloudFormation::Errors::ValidationError # Stack does not exist
        @remote = nil
        @id = nil
        @resources = {}
        @outputs = {}
      end

      def cf_get_events(pages = nil, stack_name = id)
        return [] unless exist?

        [].tap do |collection|
          @cf_client.describe_stack_events(:stack_name => stack_name).each do |page|
            pages -= 1 unless pages.nil?

            page.stack_events.each do |event|
              if @last_event_seen == event.event_id
                pages = 0 # Break page loop
                break
              end

              collection << event
            end

            break if pages == 0
          end

          @last_event_seen = collection.first.event_id unless collection.empty?
        end
      rescue Aws::CloudFormation::Errors::ValidationError # Stack does not exist
      end

      def cf_get_template
        JSON.parse(@cf_client.get_template(:stack_name => id).template_body)
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

require_relative '../model/event'
