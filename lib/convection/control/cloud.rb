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

      def deck(options = {})
        included_stacks = stack_groups[options[:stack_group]]
        included_stacks ||= options.fetch(:stack_list, [])
        return @cloudfile.deck unless !included_stacks.nil?
        @cloudfile.stacks.map { |name, stack| stack if included_stacks.include?(name) }.compact
      end

      def converge(to_stack, options = {}, &block)
        unless to_stack.nil? || stacks.include?(to_stack)
          block.call(Model::Event.new(:error, "Stack #{ to_stack } is not defined", :error)) if block
          return
        end

        deck(options).each do |stack|
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
        deck(options).each do |stack|
          block.call(Model::Event.new(:compare, "Compare local state of stack #{ stack.name } (#{ stack.cloud_name }) with remote template", :info))

          difference = stack.diff
          if difference.empty?
            difference << Model::Event.new(:unchanged, "Stack #{ stack.cloud_name } Has no changes", :info)
          end

          difference.each { |diff| block.call(diff) }

          break if !to_stack.nil? && stack.name == to_stack
          sleep rand @cloudfile.splay || 2
        end
      end
    end
  end
end
