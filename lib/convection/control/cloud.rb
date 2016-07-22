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

      def deck
        @cloudfile.deck
      end

      def stack_groups
        @cloudfile.stackgroup
      end

      def create_structure(list)
      hash = []
        deck.each do | stack|
          if list.include?(stack.name)
            hash[stack.name] = stack
          end
        end
        hash
      end

      def simple_converge(to_stack, &block)
        deck.each do |stack|

          break unless apply_converge(stack,&block)
          ## Stop on converge error
          break unless stack.success?

          ## Stop here
          break if !to_stack.nil? && stack.name == to_stack
          sleep rand @cloudfile.splay || 2
        end
      end

      def list_converge(hash, list, &block)
        list.each do |stack|
          break unless apply_converge(hash[stack],&block)

          sleep rand @cloudfile.splay || 2
        end

      end

      def apply_converge(stack, &block)
        block.call(Model::Event.new(:converge, "Stack #{ stack.name }", :info)) if block
        stack.apply(&block)

        if stack.error?
          block.call(Model::Event.new(:error, "Error converging stack #{ stack.name }", :error), stack.errors) if block
          break
        end
        stack.success?
      end

      def converge(options, &block)

        if options[:stack_group]
          stacks_to_converge = create_structure(options[:stack_group])
          list_converge(stacks_to_converge, options[:stack_group], &block)
        elsif  options[:stack_list]
          stacks_to_converge = create_structure(options[:stack_list])
          list_converge(stacks_to_converge, options[:stack_list], &block)
        else
          unless options[:stack].nil? || stacks.include?(options[:stack])
            block.call(Model::Event.new(:error, "Stack #{ options[:stack] } is not defined", :error)) if block
            return
          end
          simple_converge(options[:stack], &block)
        end

      end

      def diff(to_stack, &block)
        @cloudfile.deck.each do |stack|
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
