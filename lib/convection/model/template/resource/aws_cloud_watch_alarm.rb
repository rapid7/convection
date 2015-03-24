require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::CloudWatch::Alarm 
        ##
        class CloudWatchAlarm < Resource
          property :actions_enabled, 'ActionsEnabled'
          property :alarm_action, 'AlarmActions', :array
          property :alarm_description, 'AlarmDescription'
          property :alarm_name, 'AlarmName'
          property :comparison_operator, 'ComparisonOperator'
          property :dimension, 'Dimensions', :array
          property :evaluation_periods, 'EvaluationPeriods'
          property :insufficient_data_action, 'InsufficientDataActions', :array
          property :metric_name, 'MetricName'
          property :namespace, 'Namespace'
          property :ok_action, 'OKActions', :array
          property :period, 'Period'
          property :statistic, 'Statistic'
          property :threshold, 'Threshold'
          property :unit, 'Unit'

          def initialize(*args)
            super
            type 'AWS::CloudWatch::Alarm'
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def cloud_watch_alarm(name, &block)
        r = Model::Template::Resource::CloudWatchAlarm.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r 
      end
    end
  end
end
