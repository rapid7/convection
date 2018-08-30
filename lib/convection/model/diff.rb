require_relative './mixin/colorize'
require_relative './replace_properties'

module Convection
  module Model
    ##
    # Difference between an item in two templates
    ##
    class Diff
      extend Mixin::Colorize

      attr_reader :key
      attr_accessor :action
      attr_reader :ours
      attr_reader :theirs
      colorize :action, :green => [:create], :yellow => [:update, :retain], :red => [:delete, :replace]

      def initialize(key, ours, theirs)
        @key = key
        @ours = ours
        @theirs = theirs

        @action = if ours && theirs
                    property_name = key[/AWS::[A-Za-z0-9:]+\.[A-Za-z0-9]+/]
                    if REPLACE_PROPERTIES.include?(property_name)
                      :replace
                    else
                      :update
                    end
                  elsif ours
                    :create
                  else
                    :delete
                  end
      end

      def to_thor
        message = case action
                  when :create then "#{ key }: #{ ours }"
                  when :update then "#{ key }: #{ theirs } => #{ ours }"
                  when :replace then "#{ key }: #{ theirs } => #{ ours }"
                  when :delete then key
                  when :retain then key
                  end

        [action, message, color]
      end
    end
  end
end
