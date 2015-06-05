require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::CloudWatch::Alarm
        ##
        class CloudWatchAlarm < Resource
          type 'AWS::CloudWatch::Alarm'
          property :actions_enabled, 'ActionsEnabled', :default => true
          property :alarm_action, 'AlarmActions', :type => :list
          property :alarm_description, 'AlarmDescription'
          property :alarm_name, 'AlarmName'
          property :comparison_operator, 'ComparisonOperator'
          property :dimension, 'Dimensions', :type => :list
          property :evaluation_periods, 'EvaluationPeriods'
          property :insufficient_data_action, 'InsufficientDataActions', :type => :list
          property :metric_name, 'MetricName'
          property :namespace, 'Namespace'
          property :ok_action, 'OKActions', :type => :list
          property :period, 'Period'
          property :statistic, 'Statistic'
          property :threshold, 'Threshold'
          property :unit, 'Unit'
        end
      end
    end
  end
end
