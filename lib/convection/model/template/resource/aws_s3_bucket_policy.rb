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

          def initialize(*args)
            super
            @document = Model::Mixin::Policy.new(:name => false, :template => @template)
          end

          def terraform_import_commands(*)
            commands = ['# Run the following commands to import your infrastructure into terraform management.', '# ensure :module_path is set correctly', '']
            commands << '# Import s3 bucket and s3 bucket policy: '
            # commands << "terraform import #{module_prefix}aws_s3_bucket.#{name.underscore} #{stack.resources[name].physical_resource_id}"
            commands << ''
            commands
          end

          def to_hcl_json(*)
            policy_json = resources[name] && resources[name].document.document.to_json.gsub(stack.resources[name].physical_resource_id, bucket)
            policy_resource = {
              name.underscore => {
                bucket: bucket,
                policy: policy_json
              }
            }

            data = [{ aws_region: { current: { current: true } } }]
            vars = [{ cloud: { description: 'The cloud name for this resource.' } }]
            { resource: { aws_s3_bucket_policy: policy_resource }, data: data, variable: vars }.to_json
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
