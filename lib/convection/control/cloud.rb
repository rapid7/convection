require_relative '../model/cloudfile'
require_relative '../model/event'

module Convection
  module Control
    ##
    # Control tour Clouds
    ##
    class Cloud
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
          block.call(Model::Event.new(:error, "Cannot specify --stack-group and --stack-list at the same time", :error)) if block
          return []
        end

        # throw an error if the user specifies a nonexistent stack groups
        if options[:stack_group] && !stack_groups.key?(options[:stack_group])
          block.call(Model::Event.new(:error, "Unknown stack group: #{options[:stack_group]}", :error)) if block
          return []
        end

        # throw an error if the user specifies nonexistent stacks
        if Array(options[:stacks]).any? { |name| !@cloudfile.stacks.key?(name) }
          bad_stack_names = options[:stacks].reject { |name| @cloudfile.stacks.key?(name) }
          block.call(Model::Event.new(:error, "Stack#{'s' if bad_stack_names.length > 1} #{bad_stack_names.join(', ')} #{bad_stack_names.length > 1 ? 'do' : 'does'} not exist", :error)) if block
          return []
        end

        filter = Array(stack_groups[options[:stack_group]] || options[:stacks])

        # if no filter is specified, return the entire deck
        return stacks if filter.empty?
        @cloudfile.stacks.select { |name, stack| filter.include?(name) }
      end

      def converge(to_stack, options = {}, &block)
        filter_deck(options).each do |stack|
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

      def diff(to_stack, options = {}, &block)
        filter_deck(options, &block).each do |stack|
          #pp stack
          block.call(Model::Event.new(:compare, "Compare local state of stack #{ stack[1].name } (#{ stack[1].cloud_name }) with remote template", :info))

          difference = stack[1].diff
          if difference.empty?
            difference << Model::Event.new(:unchanged, "Stack #{ stack[1].cloud_name } Has no changes", :info)
          end

          difference.each { |diff| block.call(diff) }

          break if !to_stack.nil? && stack.name == to_stack
          sleep rand @cloudfile.splay || 2
        end
      end

    end
  end
end
