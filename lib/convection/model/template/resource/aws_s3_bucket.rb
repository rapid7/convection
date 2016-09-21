require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        # @example
        #   s3_bucket 'BucketWithSNSNotification' do
        #     bucket_name "my-bucket.blah.com"
        #     notification_configuration(
        #       'TopicConfigurations' => [
        #          {'Event' => 's3:ObjectCreated:*', 'Topic' => "arn:aws:sns:sns-topic-arn...."}
        #       ])
        #     with_output
        #   end
        class S3Bucket < Resource
          include Model::Mixin::Taggable

          type 'AWS::S3::Bucket'
          property :bucket_name, 'BucketName'
          property :access_control, 'AccessControl'
          property :cors_configuration, 'CorsConfiguration'
          property :lifecycle_configuration, 'LifecycleConfiguration'
          property :logging_configuration, 'LoggingConfiguration'
          property :notification_configuration, 'NotificationConfiguration'
          property :replication_configuration, 'ReplicationConfiguration'
          property :versioning_configuration, 'VersioningConfiguration'

          def cors_configuration(&block)
            config = ResourceProperty::S3CorsConfiguration.new(self)
            config.instance_exec(&block) if block
            properties['CorsConfiguration'].set(config)
          end

          def cors_configurationm(*args)
            warn 'DEPRECATED: "cors_configurationm" is deprecated. Please use "cors_configuration" instead. https://github.com/rapid7/convection/pull/135'
            cors_configuration(*args)
          end

          def replication_configuration(&block)
            config = ResourceProperty::S3ReplicationConfiguration.new(self)
            config.instance_exec(&block) if block
            properties['ReplicationConfiguration'].set(config)
          end

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
