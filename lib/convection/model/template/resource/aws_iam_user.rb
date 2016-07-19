require_relative '../resource'

module Convection
  module DSL
    module Template
      module Resource
        ## Role DSL
        module IAMUser
          def policy(policy_name, &block)
            add_policy = Model::Mixin::Policy.new(:name => policy_name, :template => @template)
            add_policy.instance_exec(&block) if block

            policies << add_policy
          end

          def with_key(serial = 0, &block)
            key = Model::Template::Resource::IAMAccessKey.new("#{ name }Key", @template)
            key.user_name = self
            key.serial = serial

            key.depends_on(self)

            key.with_output("#{ name }Id", key.reference)
            key.with_output("#{ name }Secret", get_att(key.name, 'SecretAccessKey'))

            key.instance_exec(&block) if block

            @template.resources[key.name] = key
          end
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::User
        ##
        class IAMUser < Resource
          # @example
          # iam_user 'User' do
          #   path "/my_path/region/example-cloud/"
          #   with_key
          #
          #   policy 'bucket-policy' do
          #     allow do
          #       s3_resource 'bucket.blah.com', '*'
          #       s3_resource 'bucket.blah.com'
          #
          #       action 's3:GetObject'
          #       action 's3:PutObject'
          #       action 's3:DeleteObject'
          #       action 's3:ListBucket'
          #     end
          #   end
          # end
          include DSL::Template::Resource::IAMUser

          type 'AWS::IAM::User'
          property :path, 'Path'
          property :login_profile, 'LoginProfile'
          property :group, 'Groups', :type => :list
          property :policies, 'Policies', :type => :list
          property :managed_policy_arn, 'ManagedPolicyArns', :type => :list
          alias managed_policy managed_policy_arn
        end
      end
    end
  end
end
