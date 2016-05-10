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
      attr_reader :exist
      attr_reader :status
      alias_method :exist?, :exist

      attr_reader :attributes
      attr_reader :errors
      attr_reader :options
      attr_reader :resources
      attr_reader :attribute_mapping_values
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
      CREATE_COMPLETE = 'CREATE_COMPLETE'.freeze
      CREATE_FAILED = 'CREATE_FAILED'.freeze
      CREATE_IN_PROGRESS = 'CREATE_IN_PROGRESS'.freeze
      DELETE_COMPLETE = 'DELETE_COMPLETE'.freeze
      DELETE_FAILED = 'DELETE_FAILED'.freeze
      DELETE_IN_PROGRESS = 'DELETE_IN_PROGRESS'.freeze
      ROLLBACK_COMPLETE = 'ROLLBACK_COMPLETE'.freeze
      ROLLBACK_FAILED = 'ROLLBACK_FAILED'.freeze
      ROLLBACK_IN_PROGRESS = 'ROLLBACK_IN_PROGRESS'.freeze
      UPDATE_COMPLETE = 'UPDATE_COMPLETE'.freeze
      UPDATE_COMPLETE_CLEANUP_IN_PROGRESS = 'UPDATE_COMPLETE_CLEANUP_IN_PROGRESS'.freeze
      UPDATE_FAILED = 'UPDATE_FAILED'.freeze
      UPDATE_IN_PROGRESS = 'UPDATE_IN_PROGRESS'.freeze
      UPDATE_ROLLBACK_COMPLETE = 'UPDATE_ROLLBACK_COMPLETE'.freeze
      UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS = 'UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS'.freeze
      UPDATE_ROLLBACK_FAILED = 'UPDATE_ROLLBACK_FAILED'.freeze
      UPDATE_ROLLBACK_IN_PROGRESS = 'UPDATE_ROLLBACK_IN_PROGRESS'.freeze

      ## Internal status
      NOT_CREATED = 'NOT_CREATED'.freeze

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
        options.delete(:disable_rollback) # There can be only one...
        @on_failure = options.delete(:on_failure) { |_| 'DELETE' }
        @capabilities = options.delete(:capabilities) { |_| ['CAPABILITY_IAM'] }

        @attributes = options.delete(:attributes) { |_| Model::Attributes.new }
        @options = options

        client_options = {}.tap do |opt|
          opt[:region] = @region
          opt[:credentials] = @credentials unless @credentials.nil?
        end
        @ec2_client = Aws::EC2::Client.new(client_options)
        @cf_client = Aws::CloudFormation::Client.new(client_options)

        ## Remote state
        @exist = false
        @status = NOT_CREATED
        @id = nil
        @outputs = {}
        @resources = {}
        @current_template = {}
        @last_event_seen = nil

        ## Get initial state
        get_status(cloud_name)
        return unless exist?

        get_resources
        get_template
        resource_attributes
        get_events(1) # Get the latest page of events (Set @last_event_seen before starting)
      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      def cloud_name
        return @cloud_name unless @cloud_name.nil?
        return name if cloud.nil?
        "#{ cloud }-#{ name }"
      end

      ##
      # Attribute Accessors
      ##
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
        @attributes.get(*args)
      end

      ##
      # Stack State
      ##
      def in_progress?
        [CREATE_IN_PROGRESS, ROLLBACK_IN_PROGRESS, DELETE_IN_PROGRESS,
         UPDATE_IN_PROGRESS, UPDATE_COMPLETE_CLEANUP_IN_PROGRESS,
         UPDATE_ROLLBACK_IN_PROGRESS,
         UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS].include?(status)
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

      ##
      # Rendderers
      ##
      def render
        @template.render
      end

      def to_json(pretty = false)
        @template.to_json(nil, pretty)
      end

      def diff
        @template.diff(@current_template)
      end

      ##
      # Controllers
      ##
      def apply(&block)
        request_options = @options.clone.tap do |o|
          o[:template_body] = to_json
          o[:parameters] = cf_parameters
          o[:capabilities] = capabilities
        end

        if exist?
          if diff.empty? ## No Changes. Just get resources and move on
            block.call(Model::Event.new(:complete, "Stack #{ name } has no changes", :info)) if block
            get_status
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

          get_status(cloud_name) # Get ID of new stack
        end

        watch(&block) if block # Block execution on stack status
      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      def delete(&block)
        @cf_client.delete_stack(
          :stack_name => id
        )

        ## Block execution on stack status
        watch(&block) if block

        get_status
      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      def watch(poll = 2, &block)
        get_status

        loop do
          get_events.reverse_each do |event|
            block.call(Model::Event.from_cf(event))
          end if block

          break unless in_progress?

          sleep poll
          get_status
        end
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
        fail result.context.http_response.inspect unless result.successful?
        puts "\nTemplate validated successfully"
      end

      private

      def get_status(stack_name = id)
        cf_stack = @cf_client.describe_stacks(:stack_name => stack_name).stacks.first

        @id = cf_stack.stack_id
        @status = cf_stack.stack_status
        @exist = true

        ## Parse outputs
        @outputs = {}.tap do |collection|
          cf_stack.outputs.each do |output|
            collection[output[:output_key].to_s] = (JSON.parse(output[:output_value]) rescue output[:output_value])
          end
        end

        ## Add outputs to attribute set
        @attributes.load_outputs(self)
      rescue Aws::CloudFormation::Errors::ValidationError # Stack does not exist
        @exist = false
        @status = NOT_CREATED
        @id = nil
        @outputs = {}
      end

      ## Fetch current resources
      def get_resources
        @resources = {}.tap do |collection|
          @cf_client.list_stack_resources(:stack_name => @id).each do |page|
            page.stack_resource_summaries.each do |resource|
              collection[resource[:logical_resource_id]] = resource
            end
          end
        end
      rescue Aws::CloudFormation::Errors::ValidationError # Stack does not exist
        @resources = {}
      end

      def get_template
        @current_template = JSON.parse(@cf_client.get_template(:stack_name => id).template_body)
      rescue Aws::CloudFormation::Errors::ValidationError # Stack does not exist
        @current_template = {}
      end

      ## Fetch new stack events
      def get_events(pages = nil, stack_name = id)
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

      ## TODO No. This will become unnecessary as current_state is fleshed out
      def resource_attributes
        @attribute_mapping_values = {}
        @template.execute ## Populate mappings fro the template

        @resources.each do |logical, resource|
          next unless @template.attribute_mappings.include?(logical)

          attribute_map = @template.attribute_mappings[logical]
          case attribute_map[:type].to_sym
          when :string
            @attribute_mapping_values[attribute_map[:name]] = resource[:physical_resource_id]
          when :array
            @attribute_mapping_values[attribute_map[:name]] = [] unless @attribute_mapping_values[attribute_map[:name]].is_a?(Array)
            @attribute_mapping_values[attribute_map[:name]].push(resource[:physical_resource_id])
          else
            fail TypeError, "Attribute Mapping must be defined with type `string` or `array`, not #{ type }"
          end
        end

        ## Add mapped resource IDs to attributes
        @attributes.load_resources(self)
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
