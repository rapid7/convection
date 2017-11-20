require 'aws-sdk'
require 'json'

module Convection
  module Control
    ##
    # The Stack class provides a state wrapper for CloudFormation
    # Stacks. It tracks the state of the managed stack, and
    # creates/updates accordingly. Stack is also region-aware, and can
    # be used within a template to define resources that depend upon
    # availability-zones or other region-specific neuances that cannot
    # be represented as maps or require iteration.
    ##
    class Stack
      attr_reader :id
      attr_reader :name
      attr_accessor :template
      # @return [Boolean] whether the stack exists and has a status
      #   other than DELETED.
      attr_reader :exist
      # @return [String] CloudFormation Stack status
      attr_reader :status
      alias_method :exist?, :exist

      attr_reader :current_template

      attr_reader :attributes
      attr_reader :errors
      attr_reader :options
      attr_reader :resources
      attr_reader :attribute_mapping_values
      attr_reader :outputs
      attr_reader :tasks

      ## AWS-SDK
      attr_accessor :region
      attr_accessor :exclude_availability_zones
      attr_accessor :cloud
      attr_reader :capabilities
      attr_accessor :credentials
      attr_reader :parameters
      attr_reader :tags
      attr_accessor :on_failure

      # Represents a stack that has successfully been converged.
      CREATE_COMPLETE = 'CREATE_COMPLETE'.freeze
      # Represents a stack that has not successfully been converged.
      CREATE_FAILED = 'CREATE_FAILED'.freeze
      # Represents a stack that is currently being converged for the first time.
      CREATE_IN_PROGRESS = 'CREATE_IN_PROGRESS'.freeze
      # Represents a stack that has successfully been deleted.
      DELETE_COMPLETE = 'DELETE_COMPLETE'.freeze
      # Represents a stack that has not successfully been deleted.
      DELETE_FAILED = 'DELETE_FAILED'.freeze
      # Represents a stack that is currently being deleted.
      DELETE_IN_PROGRESS = 'DELETE_IN_PROGRESS'.freeze
      # Represents a stack that has successfully been rolled back.
      ROLLBACK_COMPLETE = 'ROLLBACK_COMPLETE'.freeze
      # Represents a stack that has not successfully been rolled back.
      ROLLBACK_FAILED = 'ROLLBACK_FAILED'.freeze
      # Represents a stack that is currently being rolled back.
      ROLLBACK_IN_PROGRESS = 'ROLLBACK_IN_PROGRESS'.freeze
      # Represents a stack that has successfully been updated (re-converged).
      UPDATE_COMPLETE = 'UPDATE_COMPLETE'.freeze
      # Represents a stack that is currently performing post-update cleanup.
      UPDATE_COMPLETE_CLEANUP_IN_PROGRESS = 'UPDATE_COMPLETE_CLEANUP_IN_PROGRESS'.freeze
      # Represents a stack that has not successfully been updated.
      UPDATE_FAILED = 'UPDATE_FAILED'.freeze
      # Represents a stack that is currently being updated (re-converged).
      UPDATE_IN_PROGRESS = 'UPDATE_IN_PROGRESS'.freeze
      # Represents a stack that has successfully rolled back an update (re-converge).
      UPDATE_ROLLBACK_COMPLETE = 'UPDATE_ROLLBACK_COMPLETE'.freeze
      # Represents a stack that is currently performing post-update-rollback cleanup.
      UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS = 'UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS'.freeze
      # Represents a stack that has successfully been rolled back after an update.
      UPDATE_ROLLBACK_FAILED = 'UPDATE_ROLLBACK_FAILED'.freeze
      # Represents a stack that is currently performing a update rollback.
      UPDATE_ROLLBACK_IN_PROGRESS = 'UPDATE_ROLLBACK_IN_PROGRESS'.freeze

      # Represents a stack that has not been created. The default state
      # for a convection stack before getting its status.
      NOT_CREATED = 'NOT_CREATED'.freeze
      # Represents a stack task being completed.
      TASK_COMPLETE = 'TASK_COMPLETE'.freeze
      # Represents a stack task having failed.
      TASK_FAILED = 'TASK_FAILED'.freeze
      # Represents a stack task that is currently in progress.
      TASK_IN_PROGRESS = 'TASK_IN_PROGRESS'.freeze

      # @param name [String] the name of the CloudFormation Stack
      # @param template [Convection::Model::Template] a wrapper of the
      #   CloudFormation template (can be rendered into CF JSON)
      # @param options [Hash] an options hash to pass in advanced
      #   configuration options. Undocumented options will be passed
      #   directly to CloudFormation's #create_stack or #update_stack.
      # @option options [String] :region AWS region, format us-east-1. Default us-east-1
      # @option options [Hash] :credentials optional instance of `Aws::Credentials`
      # @option options [Hash] :parameters CloudFormation Stack parameters
      # @option options [String] :tags CloudFormation Stack tags
      # @option options [String] :on_failure the create failure action. Default: `DELETE`
      # @option options [Array<String>] :capabilities A list of capabilities (such as `CAPABILITY_IAM`).
      #   See also {http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Client.html#create_stack-instance_method Aws::CloudFormation::Client#create_stack}
      def initialize(name, template, options = {}, &block)
        @name = name
        @template = template.clone(self)
        @errors = []

        @cloud = options.delete(:cloud)
        @cloud_name = options.delete(:cloud_name)
        @region = options.delete(:region) { |_| 'us-east-1' }
        @exclude_availability_zones = options.delete(:exclude_availability_zones) { |_| [] } # Default empty Array
        @credentials = options.delete(:credentials)
        @parameters = options.delete(:parameters) { |_| {} } # Default empty hash
        @tags = options.delete(:tags) { |_| {} } # Default empty hash
        options.delete(:disable_rollback) # There can be only one...
        @on_failure = options.delete(:on_failure) { |_| 'DELETE' }
        @capabilities = options.delete(:capabilities) { |_| %w(CAPABILITY_IAM CAPABILITY_NAMED_IAM) }

        @attributes = options.delete(:attributes) { |_| Model::Attributes.new }
        @options = options
        @retry_limit = options[:retry_limit] || 7

        client_options = {}.tap do |opt|
          opt[:region] = @region
          opt[:credentials] = @credentials unless @credentials.nil?
          opt[:retry_limit] = @retry_limit
        end
        @ec2_client = Aws::EC2::Client.new(client_options)
        @cf_client = Aws::CloudFormation::Client.new(client_options)

        ## Remote state
        @exist = false
        @status = NOT_CREATED
        @id = nil
        @outputs = {}
        @resources = {}
        @tasks = { after_create: [], after_delete: [], after_update: [], before_create: [], before_delete: [], before_update: [] }
        instance_exec(&block) if block
        @current_template = {}
        @last_event_seen = nil

        # First pass evaluation of stack
        # This is important because it:
        #   * Catches syntax errors before starting a converge
        #   * Builds a list of all resources that allows stacks early in
        #     the dependency tree to know about later stacks.  Some
        #     clouds use this, for example, to create security groups early
        #     in the dependency tree to avoid the chicken-and-egg problem.
        @template.execute

      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      def template_status
        get_status(cloud_name)
      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      def load_template_info
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

      # @!group Attribute accessors

      # @overload include?(key)
      #   @param key [String] the name of the attribute to find
      # @overload include?(stack_name, key)
      #   @param stack_name [String] the name of the stack to check within
      #   @param key [String] the name of the attribute to find
      # @return [Boolean] whether the stack includes the specified key.
      def include?(stack, key = nil)
        return @attributes.include?(name, stack) if key.nil?
        @attributes.include?(stack, key)
      end

      # @see Convection::Model::Attributes#get
      def [](key)
        @attributes.get(name, key)
      end

      # @see Convection::Model::Attributes#set
      def []=(key, value)
        @attributes.set(name, key, value)
      end

      # @see Convection::Model::Attributes#fetch
      def fetch(*args)
        @attributes.fetch(*args)
      end

      # @see Convection::Model::Attributes#get
      def get(*args)
        @attributes.get(*args)
      end

      # @!endgroup

      # @!group Stack state methods

      # @return [Boolean] whether or not the CloudFormation Stack is in
      #   one of several *IN_PROGRESS states.
      def in_progress?
        [CREATE_IN_PROGRESS, ROLLBACK_IN_PROGRESS, DELETE_IN_PROGRESS,
         UPDATE_IN_PROGRESS, UPDATE_COMPLETE_CLEANUP_IN_PROGRESS,
         UPDATE_ROLLBACK_IN_PROGRESS,
         UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS].include?(status)
      end

      # @return [Boolean] whether the CloudFormation Stack is in one of
      #   the several *_COMPLETE states.
      def complete?
        [CREATE_COMPLETE, ROLLBACK_COMPLETE, UPDATE_COMPLETE, UPDATE_ROLLBACK_COMPLETE].include?(status)
      end

      # @return [Boolean] whether a credential error occurred is the reason
      #   accessing the CloudFormation stack failed.
      def credential_error?
        error? && errors.all? { |e| e.class == Aws::EC2::Errors::RequestExpired }
      end

      # @return [Boolean] whether the CloudFormation Stack is in one of
      #   the several *_COMPLETE states.
      def delete_complete?
        DELETE_COMPLETE == status
      end

      # @return [Boolean] whether the Stack state is now {#delete_complete?} (with no errors present).
      def delete_success?
        !error? && delete_complete?
      end

      # @return [Boolean] whether the CloudFormation Stack is in one of
      #   the several *_FAILED states.
      def fail?
        [CREATE_FAILED, ROLLBACK_FAILED, DELETE_FAILED, UPDATE_ROLLBACK_FAILED].include?(status)
      end

      # @return [Boolean] whether any errors occurred modifying the
      #   stack.
      def error?
        !errors.empty?
      end

      # @return [Boolean] whether the Stack state is now {#complete?} (with no errors present).
      def success?
        !error? && complete?
      end

      # @!endgroup

      # @!group Render/diff methods

      # @see Convection::Model::Template#render
      def render
        @template.render
      end

      # @param pretty [Boolean] whether to to pretty-print the JSON output
      # @return the renedered CloudFormation Template JSON.
      # @see Convection::Model::Template#to_json
      def to_json(pretty = false)
        @template.to_json(nil, pretty)
      end

      # @return [Hash] a set of differences between the current
      #   template (in CloudFormation) and the state of the rendered
      #   template (what *would* be converged).
      # @see Convection::Model::Template#diff
      def diff(retain: false)
        @template.diff(@current_template, retain: retain)
      end

      # @return [Boolean] whether the Resources section of the rendered
      #   template has any changes compared to the current template (in
      #   CloudFormation).
      def resource_changes?
        ours = { 'Resources' => @template.all_resources.map(&:render) }
        thiers = { 'Resources' => @current_template['Resources'] }

        ours.diff(thiers).any?
      end

      # @return [Boolean] whether the any template sections dependent
      #   on the Resources section of the rendered template has any
      #   changes compared to the current template (in CloudFormation).
      #   For example Conditions, Metadata, and Outputs depend on
      #   changes to resources to be able to converge. See also
      #   {https://github.com/rapid7/convection/issues/140
      #   rapid7/convection#140}.
      def resource_dependent_changes?
        ours = {
          'Conditions' => @template.conditions.map(&:render),
          'Outputs' => @template.outputs.map(&:render)
        }
        theirs = {
          'Conditions' => @current_template['Conditions'],
          'Outputs' => @current_template['Outputs']
        }

        ours.diff(theirs).any?
      end

      # @!endgroup

      # @!group Controllers

      # Render the CloudFormation template and apply the Stack using
      # the CloudFormation client.
      #
      # @param block [Proc] a configuration block to pass any
      #   {Convection::Model::Event}s to.
      def apply(&block)
        request_options = @options.clone.tap do |o|
          o[:template_body] = to_json
          o[:parameters] = cf_parameters
          o[:capabilities] = capabilities
        end

        # Get the state of existence before creation
        existing_stack = exist?
        if existing_stack
          if diff.empty? ## No Changes. Just get resources and move on
            block.call(Model::Event.new(:complete, "Stack #{ name } has no changes", :info)) if block
            get_status
            return
          elsif !resource_changes? && resource_dependent_changes?
            message = "Stack #{ name } has no convergable changes (you must update Resources to update Conditions, Metadata, or Outputs)"
            block.call(Model::Event.new(UPDATE_FAILED, message, :warn)) if block
            get_status
            return
          end

          ## Execute before update tasks
          @tasks[:before_update].delete_if do |task|
            run_task(:before_update, task, &block)
          end

          ## Update
          @cf_client.update_stack(request_options.tap do |o|
            o[:stack_name] = id
          end)
        else
          ## Execute before create tasks
          @tasks[:before_create].delete_if do |task|
            run_task(:before_create, task, &block)
          end

          ## Create
          @cf_client.create_stack(request_options.tap do |o|
            o[:stack_name] = cloud_name

            o[:tags] = cf_tags
            o[:on_failure] = on_failure
          end)

          get_status(cloud_name) # Get ID of new stack
        end

        watch(&block) if block # Block execution on stack status

        ## Execute after create tasks
        after_task_type = existing_stack ? :after_update : :after_create
        @tasks[after_task_type].delete_if do |task|
          run_task(after_task_type, task, &block)
        end
      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      # Delete the CloudFormation Stack using the CloudFormation client.
      #
      # @param block [Proc] a configuration block to pass any
      #   {Convection::Model::Event}s to.
      def delete(&block)
        ## Execute before delete tasks
        @tasks[:before_delete].delete_if do |task|
          run_task(:before_delete, task, &block)
        end

        @cf_client.delete_stack(
          :stack_name => id
        )

        ## Block execution on stack status
        watch(&block) if block

        get_status

        ## Execute after delete tasks
        @tasks[:after_delete].delete_if do |task|
          run_task(:after_delete, task, &block)
        end
      rescue Aws::Errors::ServiceError => e
        @errors << e
      end

      # @!endgroup

      # Loops through current events until the CloudFormation Stack has
      # finished being modified.
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

      # @param block [Proc] a block to pass each availability zone
      #   (with its index)
      # @return [Array<String>] the list of availability zones found by
      #   the call to ec2 client's describe availability zones
      def availability_zones(&block)
        @availability_zones ||=
          @ec2_client.describe_availability_zones.availability_zones.map(&:zone_name)

        unless @exclude_availability_zones.empty?
          @availability_zones.reject! { |az| @exclude_availability_zones.include?(az) }
        end
        if @availability_zones.empty? && block
          fail 'There are no AvailabilityZones, check exclude_availability_zones in the Cloudfile.'
        end
        @availability_zones.sort!

        @availability_zones.each_with_index(&block) if block
        @availability_zones
      end

      # Validates a rendered template against the CloudFormation API.
      #
      # @raise unless the validation was successful
      def validate
        result = @cf_client.validate_template(:template_body => template.to_json)
        fail result.context.http_response.inspect unless result.successful?
        puts "\nTemplate validated successfully"
      end

      # @!group Task methods

      # Register a given task to run after creation of a stack.
      def after_create_task(task)
        @tasks[:after_create] << task
      end

      # Register a given task to run after deletion of a stack.
      def after_delete_task(task)
        @tasks[:after_delete] << task
      end

      # Register a given task to run after an update of a stack.
      def after_update_task(task)
        @tasks[:after_update] << task
      end

      # Register a given task to run before creation of a stack.
      def before_create_task(task)
        @tasks[:before_create] << task
      end

      # Register a given task to run before deletion of a stack.
      def before_delete_task(task)
        @tasks[:before_delete] << task
      end

      # Register a given task to run before an update of a stack.
      def before_update_task(task)
        @tasks[:before_update] << task
      end

      # @!endgroup

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

      def run_task(phase, task, &block)
        phase = phase.to_s.split.join(' ')
        block.call(Model::Event.new(TASK_IN_PROGRESS, "Task (#{phase}) #{task} in progress for stack #{name}.", :info)) if block

        task.call(self)
        return task.success? unless block

        if task.success?
          block.call(Model::Event.new(TASK_COMPLETE, "Task (#{phase}) #{task} successfully completed for stack #{name}.", :info))
          true
        else
          block.call(Model::Event.new(TASK_FAILED, "Task (#{phase}) #{task} failed to complete for stack #{name}.", :error))
          false
        end
      end
    end
  end
end

require_relative '../model/event'
