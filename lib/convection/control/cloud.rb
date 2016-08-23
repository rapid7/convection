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

      def converge(to_stack, options = {}, &block)
        if to_stack && !stacks.include?(to_stack)
          block.call(Model::Event.new(:error, "Undefined Stack #{ to_stack }", :error)) if block
          return
        end

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

      def diff(to_stack, options = {}, &block)
        if to_stack && !stacks.include?(to_stack)
          block.call(Model::Event.new(:error, "Undefined Stack #{ to_stack }", :error)) if block
          return
        end

        filter_deck(options, &block).each_value do |stack|
          block.call(Model::Event.new(:compare, "Compare local state of stack #{ stack.name } (#{ stack.cloud_name }) with remote template", :info))

          difference = stack.diff
          if difference.empty?
            difference << Model::Event.new(:unchanged, "Stack #{ stack.cloud_name } has no changes", :info)
          end

          difference.each { |diff| block.call(diff) }

          break if !to_stack.nil? && stack.name == to_stack
          sleep rand @cloudfile.splay || 2
        end
      end
    end
  end
end
