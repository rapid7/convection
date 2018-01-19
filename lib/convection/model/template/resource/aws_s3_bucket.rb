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
          property :website_configuration, 'WebsiteConfiguration'

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

          def website_configuration(&block)
            config = ResourceProperty::S3WebsiteConfiguration.new(self)
            config.instance_exec(&block) if block
            properties['WebsiteConfiguration'].set(config)
          end

          def terraform_import_commands(module_path: 'root')
            commands = ['# Run the following commands to import your infrastructure into terraform management.', '# ensure :module_path is set correctly', '']
            module_prefix = "#{module_path}." unless module_path == 'root'

            commands << '# Import s3 bucket and s3 bucket policy: '
            commands << "terraform import #{module_prefix}aws_s3_bucket.#{name.underscore} #{stack.resources[name].physical_resource_id}"
            commands << ''
            commands
          end

          def to_hcl_json(*)
            bucket_resource = {
              name.underscore => {
                bucket: stack.resources[name].physical_resource_id,
                acl: 'private',
                force_destroy: false
              }
            }

            data = [{ aws_region: { current: { current: true } } }]
            vars = [{ cloud: { description: 'The cloud name for this resource.' } }]
            { resource: [{ aws_s3_bucket: bucket_resource }], data: data, variable: vars }.to_json
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
