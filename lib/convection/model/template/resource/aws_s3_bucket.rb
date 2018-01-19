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

          def full_name(terraform_import: false)
            return "#{name.downcase}.#{stack._original_cloud}.#{stack._original_region}.rapid7.com" if terraform_import

            "#{name.downcase}.#{stack.cloud}.#{stack.region}.rapid7.com"
          end

          def hcl_imports(module_path: 'root')
            commands = ['# Run the following commands to import your infrastructure into terraform management.', '# ensure :module_path is set correctly', '']
            module_prefix = module_path.tr('.', '-') if module_path == 'root'
            result = {}

            commands << '# Import s3 bucket and s3 bucket policy: '
            commands << "terraform import #{module_prefix}aws_s3_bucket.#{name.downcase} #{full_name(terraform_import: true)}"
						commands << ''
						commands
          end

          def to_hcl_json(module_path: 'root')
            bucket_resource = {
              name.downcase => {
                bucket: full_name,
                acl: "private",
                force_destroy: false,
              }
            }

            data = [{aws_region: {current: {current: true } } }]
            tf_resources = [
              { aws_s3_bucket: bucket_resource },
            ]

            bucket_reference = "${aws_s3_bucket.#{name.downcase}.id}"
              policy_json = resources["#{name}Policy"] && resources["#{name}Policy"].document.document.to_json.gsub(full_name, bucket_reference)
              policy_resource = {
                name.downcase => {
                  bucket: bucket_reference,
                  policy: policy_json.render.to_json,
                }
              }

              tf_resources << { aws_s3_bucket_policy: policy_resource }
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
