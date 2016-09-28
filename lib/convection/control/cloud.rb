require_relative '../model/cloudfile'
require_relative '../model/event'

module Convection
  module Control
    ##
    # Control tour Clouds
    ##
    class Cloud
      attr_accessor :cloudfile
      def configure(cloudfile)
        @cloudfile = Model::Cloudfile.new(cloudfile)
      end

      # @see Convection::Model::Cloudfile#stacks
      def stacks
        @cloudfile.stacks
      end

      def stack_groups
        @cloudfile.stack_groups
      end

      def filter_deck(options = {}, &block)
        # throw an error if the user specifies both a stack group and list of stacks
        if options[:stack_group] && options[:stacks]
          block.call(Model::Event.new(:error, 'Cannot specify --stack-group and --stack-list at the same time', :error)) if block
          return {}
        end

        # throw an error if the user specifies a nonexistent stack groups
        if options[:stack_group] && !stack_groups.key?(options[:stack_group])
          block.call(Model::Event.new(:error, "Unknown stack group: #{options[:stack_group]}", :error)) if block
          return {}
        end

        # throw an error if the user specifies nonexistent stacks
        if Array(options[:stacks]).any? { |name| !@cloudfile.stacks.key?(name) }
          bad_stack_names = options[:stacks].reject { |name| @cloudfile.stacks.key?(name) }
          block.call(Model::Event.new(:error, "Undefined Stack(s) #{bad_stack_names.join(', ')}", :error)) if block
          return {}
        end

        filter = Array(stack_groups[options[:stack_group]] || options[:stacks])

        # if no filter is specified, return the entire deck
        return stacks if filter.empty?
        filter.reduce({}) do |result, stack_name|
          result.merge(stack_name => @cloudfile.stacks[stack_name])
        end
      end

      def stacks_until(last_stack_name, options = {}, &block)
        stacks = filter_deck(options, &block).values
        return stacks if last_stack_name.nil?

        last_stack = stacks.find { |stack| stack.name == last_stack_name }
        unless last_stack
          block.call(Model::Event.new(:error, "Stacks filter did not include last stack #{ last_stack }", :error)) if block
          return []
        end

        last_stack_index = stacks.index(last_stack)
        stacks[0..last_stack_index]
      end

      def converge(to_stack, options = {}, &block)
        if to_stack && !stacks.include?(to_stack)
          block.call(Model::Event.new(:error, "Undefined Stack #{ to_stack }", :error)) if block
          return
        end

        exit 1 if stack_initialization_errors?(&block)

        filter_deck(options, &block).each_value do |stack|
          block.call(Model::Event.new(:converge, "Stack #{ stack.name }", :info)) if block
          stack.apply(&block)

          if stack.error?
            block.call(Model::Event.new(:error, "Error converging stack #{ stack.name }", :error), stack.errors) if block
            break
          end

          ## Stop on converge error
          break unless stack.success?

          ## Stop here
          break if !to_stack.nil? && stack.name == to_stack
          sleep rand @cloudfile.splay || 2
        end
      end

      def delete(stacks, &block)
        exit 1 if stack_initialization_errors?(&block)

        stacks.each do |stack|
          unless stack.exist?
            block.call(Model::Event.new(:delete_skipped, "Stack #{ stack.cloud_name } does not exist remotely", :warn))
            next
          end

          block.call(Model::Event.new(:deleted, "Delete remote stack #{ stack.cloud_name }", :info)) if block
          stack.delete(&block)

          if stack.error?
            block.call(Model::Event.new(:error, "Error deleting stack #{ stack.name }", :error), stack.errors) if block
            break
          end

          break unless stack.delete_success?

          sleep rand @cloudfile.splay || 2
        end
      end

      def diff(to_stack, options = {}, &block)
        if to_stack && !stacks.include?(to_stack)
          block.call(Model::Event.new(:error, "Undefined Stack #{ to_stack }", :error)) if block
          return
        end

        exit 1 if stack_initialization_errors?(&block)

        filter_deck(options, &block).each_value do |stack|
          block.call(Model::Event.new(:compare, "Compare local state of stack #{ stack.name } (#{ stack.cloud_name }) with remote template", :info))

          difference = stack.diff
          # Find errors during diff
          if stack.error?
            errors = stack.errors.collect { |x| x.exception.message }
            errors = errors.uniq.flatten
            block.call(Model::Event.new(:error, "Error diffing stack #{ stack.name} Error(s): #{errors.join(', ')}", :error), stack.errors) if block
            break
          end

          if difference.empty?
            difference << Model::Event.new(:unchanged, "Stack #{ stack.cloud_name } has no changes", :info)
          end

          difference.each { |diff| block.call(diff) }

          break if !to_stack.nil? && stack.name == to_stack
        end
      end

      def stack_initialization_errors?(&block)
        errors = []
        # Find errors during stack init
        stacks.each_value do |stack|
          if stack.error?
            errors << stack.errors.collect { |x| x.exception.message }
          end
        end

        unless errors.empty?
          errors = errors.uniq.flatten
          block.call(Model::Event.new(:error, "Error(s) during stack initialization #{errors.join(', ')}", :error), errors) if block
          return true
        end
        false
      end
    end
  end
end
