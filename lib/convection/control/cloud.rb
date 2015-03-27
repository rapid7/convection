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
          block.call(Model::Event.new(:diff, "Compare local state of #{ stack.name } (#{ stack.cloud_name }) with remote template", :status))
          next stack.diff.each { |diff| block.call(diff) } if stack.exist?
          block.call(Model::Event.new(:create, "Stack #{ stack.cloud_name } is not yet defined", :info))
        end
      end
    end
  end
end
