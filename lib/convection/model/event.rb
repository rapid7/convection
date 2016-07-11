require_relative './mixin/colorize'
require_relative '../control/stack'

module Convection
  module Model
    ##
    # Wrap events with some smarts
    ##
    class Event
      extend Mixin::Colorize

      attr_accessor :name
      attr_accessor :message
      attr_accessor :level
      attr_accessor :timestamp
      colorize :level,
               :green => [:info, :success, Control::Stack::CREATE_COMPLETE, Control::Stack::UPDATE_COMPLETE, Control::Stack::UPDATE_ROLLBACK_COMPLETE,
                          Control::Stack::TASK_COMPLETED],
               :red => [:error, :fail, Control::Stack::CREATE_FAILED, Control::Stack::ROLLBACK_FAILED,
                        Control::Stack::DELETE_FAILED, Control::Stack::UPDATE_FAILED,
                        Control::Stack::UPDATE_ROLLBACK_IN_PROGRESS, Control::Stack::UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS,
                        Control::Stack::UPDATE_ROLLBACK_FAILED, Control::Stack::TASK_FAILED],
               :blue => [Control::Stack::TASK_IN_PROGRESS],
               :default => :yellow

      class << self
        def from_cf(event)
          Event.new(event.resource_status.downcase,
                    "#{ event.logical_resource_id }: (#{ event.resource_type }/"\
                    "#{ event.physical_resource_id}) #{ event.resource_status_reason }",
                    event.resource_status,
                    :event_id => event.event_id,
                    :logical_resource_id => event.logical_resource_id,
                    :physical_resource_id => event.physical_resource_id,
                    :resource_properties => event.resource_properties,
                    :resource_status_reason => event.resource_status_reason,
                    :resource_type => event.resource_type,
                    :stack_id => event.stack_id,
                    :stack_name => event.stack_name,
                    :timestamp => event.timestamp)
        end
      end

      def initialize(name, message, level = :info, attributes = {})
        @name = name
        @message = message
        @level = level
        @attributes = attributes
      end

      def [](attr)
        @attributes[attr]
      end

      def []=(attr, value)
        @attributes[attr] = value
      end

      def to_thor
        [name.downcase, message, color]
      end
    end
  end
end
