require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        # @example
        #   rds_event_subscription 'myEventSubscription' do
        #     event_category 'configuration change'
        #     event_category 'failure'
        #     event_category 'deletion'
        #     sns_topic_arn  'arn:aws:sns:us-west-2:123456789012:example-topic'
        #     source_id      'db-instance-1'
        #     source_id      fn_ref('myDBInstance')
        #     source_type    'db-instance'
        #     enabled        false
        #   end
        class RDSEventSubscription < Resource
          type 'AWS::RDS::EventSubscription'
          property :enabled, 'Enabled'
          property :event_category, 'EventCategories', :type => :list
          property :sns_topic_arn, 'SnsTopicArn'
          property :source_id, 'SourceIds', :type => :list
          property :source_type, 'SourceType'
        end
      end
    end
  end
end
