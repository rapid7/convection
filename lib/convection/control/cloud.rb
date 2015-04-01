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

      def stacks
        @cloudfile.stacks
      end

      def deck
        @cloudfile.deck
      end

      def converge(to_stack, &block)
        unless to_stack.nil? || stacks.include?(to_stack)
          block.call(Model::Event.new(:error, "Stack #{ to_stack } is not defined", :error)) if block
          return
        end

        deck.each do |stack|
          block.call(Model::Event.new(:converge, "Stack #{ stack.name }", :info)) if block
          stack.apply(&block)

          if stack.error?
            block.call(Model::Event.new(:error, "Error converging stack #{ stack.name }", :error), stack.errors) if block
            return
          end

          ## Stop here
          return if !to_stack.nil? && stack.name == to_stack
        end
      end

      def diff(&block)
        @cloudfile.deck.each do |stack|
          block.call(Model::Event.new(:compare, "Compare local state of stack #{ stack.name } (#{ stack.cloud_name }) with remote template", :info))
          next block.call(Model::Event.new(:create, "Stack #{ stack.cloud_name } is not yet defined", :info)) unless stack.exist?

          difference = stack.diff
          next block.call(Model::Event.new(:unchanged, "Stack #{ stack.cloud_name } Has no changes", :info)) if difference.empty?

          difference.each { |diff| block.call(diff) }
        end
      end
    end
  end
end
