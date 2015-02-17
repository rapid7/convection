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

          property :bucket_name, 'BucketName'
          property :access_control, 'AccessControl'
          property :cors_configurationm, 'CorsConfiguration'
          property :lifecycle_configuration, 'LifecycleConfiguration'
          property :logging_configuration, 'LoggingConfiguration'
          property :notification_configuration, 'NotificationConfiguration'
          property :version_configuration, 'VersionConfiguration'

          def initialize(*args)
            super
            type 'AWS::S3::Bucket'
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

  module DSL
    ## Add DSL method to template namespace
    module Template
      def s3_bucket(name, &block)
        r = Model::Template::Resource::S3Bucket.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
