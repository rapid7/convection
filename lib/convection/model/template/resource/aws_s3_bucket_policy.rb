require 'forwardable'
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        # @example
        #   s3_bucket_policy 'BucketPolicy' do
        #     bucket "my-bucket"
        #
        #     allow do
        #       principal :AWS => '*'
        #       s3_resource "my-bucket", '*'
        #       action 's3:GetObject'
        #     end
        #   end
        class S3BucketPolicy < Resource
          extend Forwardable

          type 'AWS::S3::BucketPolicy'
          property :bucket, 'Bucket'
          attr_reader :document # , 'PolicyDocument'

          def_delegators :@document, :allow, :deny, :id, :version, :statement
          def_delegator :@document, :name, :policy_name
          def_delegators :@document, :deny, :id, :version, :statement

          def initialize(*args)
            super
            @document = Model::Mixin::Policy.new(:name => false, :template => @template)
          end

          def render
            super.tap do |r|
              document.render(r['Properties'])
            end
          end
        end
      end
    end
  end
end
