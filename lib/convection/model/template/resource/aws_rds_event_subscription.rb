require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::RDS::EventSubscription
        ##
        class RDSEventSubscription < Resource
          type 'AWS::RDS::EventSubscription', :rds_instance
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
