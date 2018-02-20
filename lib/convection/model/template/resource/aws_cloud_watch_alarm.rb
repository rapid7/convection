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

          def terrafom_import_commands(module_path: 'root')
            commands = ['Run the following commands to import your infrastructure into terraform management.', '# ensure :module_path is set correctly', '']
            commands << "terraform import #{module_prefix}aws_cloudwatch_metric_alarm.#{name.underscore} #{stack.resources[name].physical_resource_id}"
            commands << ''
            commands
          end

          def to_hcl_json(*)
            tf_alarm_attrs = {
              alarm_name: alarm_name,
              comparison_operator: comparison_operator,
              evaluation_periods: evaluation_periods,
              metric_name: metric_name,
              namespace: namespace,
              period: period,
              statistic: statistic,
              threshold: threshold,
              actions_enabled: actions_enabled,
              alarm_actions: alarm_action,
              alarm_description: alarm_description,
              dimensions: dimension,
              insufficient_data_actions: insufficient_data_action,
              ok_actions: ok_action,
              unit: unit
            }

            tf_alarm = {
              aws_cloudwatch_metric_alarm: {
                name.underscore => tf_alarm_attrs
              }
            }

            { resource: [tf_alarm] }.to_json
          end
        end
      end
    end
  end
end
