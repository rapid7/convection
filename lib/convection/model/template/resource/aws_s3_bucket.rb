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

          def initialize(*args)
            super
            type 'AWS::S3::Bucket'
          end

          def access_control(value)
            property('AccessControl', value)
          end

          def bucket_name(value)
            property('BucketName', value)
          end

          def cors_configuration(value)
            property('CorsConfiguration', value)
          end

          def lifecycle_configuration(value)
            property('LifecycleConfiguration', value)
          end

          def logging_configuration(value)
            property('LoggingConfiguration', value) 
          end

          def notification_configuration(value)
            property('NotificationConfiguration', value)
          end

          def version_configuration(value)
            property('VersionConfiguration', value)
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
