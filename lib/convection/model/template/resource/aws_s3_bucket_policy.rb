require 'forwardable'
require_relative '../resource'

module Convection
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

  module Model
    class Template
      class Resource
        ##
        # AWS::S3::BucketPolicy
        ##
        class S3BucketPolicy < Resource
          extend Forwardable

          property :bucket, 'Bucket'
          attr_reader :document #, 'PolicyDocument'

          def_delegators :@document, :allow, :id, :version, :statement
          def_delegator :@document, :name, :policy_name

          def initialize(*args)
            super
            type 'AWS::S3::BucketPolicy'
            @document = Model::Mixin::Policy.new(:name => false, :template => @template)
          end

          def render
            document.render(@properties)
            super
          end
        end
      end
    end
  end
end
