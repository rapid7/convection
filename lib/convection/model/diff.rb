require_relative './mixin/colorize'

module Convection
  module Model
    ##
    # Difference between an item in two templates
    ##
    class Diff
      extend Mixin::Colorize

      attr_reader :key
      attr_reader :action
      attr_reader :ours
      attr_reader :theirs
      colorize :action, :green => [:create], :yellow => [:update], :red => [:delete]

      def initialize(key, ours, theirs)
        @key = key
        @ours = ours
        @theirs = theirs

        @action = if ours && theirs then :update
                  elsif ours then :create
                  else :delete
                  end
      end

      def to_thor
        message = case action
                  when :create then "#{ key }: #{ ours }"
                  when :update then "#{ key }: #{ theirs } => #{ ours }"
                  when :delete then key
                  end

        [action, message, color]
      end
    end
  end
end
