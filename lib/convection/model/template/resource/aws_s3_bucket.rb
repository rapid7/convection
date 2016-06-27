require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::S3::Bucket
        ##
        class S3Bucket < Resource
          include Model::Mixin::Taggable

          type 'AWS::S3::Bucket'
          property :bucket_name, 'BucketName'
          property :access_control, 'AccessControl'
          property :cors_configuration, 'CorsConfiguration'
          property :lifecycle_configuration, 'LifecycleConfiguration'
          property :logging_configuration, 'LoggingConfiguration'
          property :notification_configuration, 'NotificationConfiguration'
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

          def lifecycle_configuration(&block)
            config = ResourceProperty::S3LifecycleConfiguration.new(self)
            config.instance_exec(&block) if block
            properties['LifecycleConfiguration'].set(config)
          end

          def logging_configuration(&block)
            config = ResourceProperty::S3LoggingConfiguration.new(self)
            config.instance_exec(&block) if block
            properties['LoggingConfiguration'].set(config)
          end

          def notification_configuration(&block)
            config = ResourceProperty::S3NotificationConfiguration.new(self)
            config.instance_exec(&block) if block
            properties['NotificationConfiguration'].set(config)
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
