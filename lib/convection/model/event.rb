module Convection
  module Model
    ##
    # Wrap events with some smarts
    ##
    class Event
      attr_accessor :name
      attr_accessor :message
      attr_accessor :level

      def initialize(name, message, level = :info)
        @name = name
        @message = message
        @level = level
      end

      def color
        case level
        when :info, :success then :green
        when :warn, :update then :yellow
        when :error, :fail then :red
        else :cyan
        end
      end

      def to_thor
        [name.downcase, message, color]
      end
    end
  end
end
