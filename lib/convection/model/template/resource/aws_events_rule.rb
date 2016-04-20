require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Events::Rule
        ##
        class EventsRule < Resource
          type 'AWS::Events::Rule'
          property :description, 'Description'
          property :domain, 'Domain'
          property :event_pattern, 'EventPattern', :type => :hash
          property :name, 'Name'
          property :role_arn, 'RoleArn'
          property :schedule_expression, 'ScheduleExpression'
          property :state, 'State'
          property :targets, 'Targets', :type => :array

          def target(&block)
            target = ResourceProperty::EventsRuleTarget.new(self)
            target.instance_exec(&block) if block
            targets << target
          end
        end
      end
    end
  end
end
