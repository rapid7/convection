require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::S3::BucketPolicy
        ##
        class S3BucketPolicy < Resource

          def initialize(*args)
            super
            type 'AWS::S3::BucketPolicy'
          end

          def bucket(value)
            property('Bucket', value)
          end

          def policy_document(value)
            property('PolicyDocument', value)
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def s3_bucket_policy(name, &block)
        r = Model::Template::Resource::S3BucketPolicy.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
