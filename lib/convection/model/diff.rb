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
      colorize :action, :green => [:create], :yellow => [:update], :red => [:delete, :replace]

      # Properties for which a change requires a replacement
      # (as opposed to an in-place update)
      REPLACE_PROPERTIES = [
        "AWS::Route53::HostedZone.Name",
        # TODO: Add more
      ]

      def initialize(key, ours, theirs)
        @key = key
        @ours = ours
        @theirs = theirs

        @action = :delete
        if ours && theirs
          property_name = key[/AWS::[A-Za-z0-9:]+\.[A-Za-z0-9]+/]
          if REPLACE_PROPERTIES.include? property_name
            @action = :replace
          else
            @action = :update
          end
        elsif ours
          @action = :create
        end
      end

      def to_thor
        message = case action
                  when :create then "#{ key }: #{ ours }"
                  when :update then "#{ key }: #{ theirs } => #{ ours }"
                  when :replace then "#{ key }: #{ theirs } => #{ ours }"
                  when :delete then key
                  end

        [action, message, color]
      end
    end
  end
end
