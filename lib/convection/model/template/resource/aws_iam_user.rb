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
        # @example
        #   iam_user 'User' do
        #     path "/my_path/region/example-cloud/"
        #     with_key
        #
        #     policy 'bucket-policy' do
        #       allow do
        #         s3_resource 'bucket.blah.com', '*'
        #         s3_resource 'bucket.blah.com'
        #
        #         action 's3:GetObject'
        #         action 's3:PutObject'
        #         action 's3:DeleteObject'
        #         action 's3:ListBucket'
        #       end
        #     end
        #   end
        class IAMUser < Resource
          include DSL::Template::Resource::IAMUser

          type 'AWS::IAM::User'
          property :group, 'Groups', :type => :list
          property :login_profile, 'LoginProfile'
          property :managed_policy_arn, 'ManagedPolicyArns', :type => :list
          alias managed_policy managed_policy_arn
          property :path, 'Path'
          property :policies, 'Policies', :type => :list
          property :user_name, 'UserName'

          def terraform_import_commands(module_path: 'root')
            prefix = "#{module_path}." unless module_path == 'root'
            resource_id = stack.resources[name] && stack.resources[name].physical_resource_id
            commands = ['# Import the aws_iam_user:']
            commands << "terraform import #{prefix}aws_iam_user.#{name.underscore} #{resource_id}"

            if Array(policies).any?
              commands << ''
              commands << '# Unable to import aws_iam_user_policy resources (inline policies).'
              commands << "# Future versions of terraform may support import using:"
            end
            Array(policies).each do |policy|
              commands << "# terraform import #{prefix}aws_iam_user_policy.#{policy.name.underscore} #{resource_id}:#{policy.name}"
            end

            commands << '# Unable import any iam user login profiles' if Array(login_profile).any?
            Array(login_profile).each do |profile|
              commands << "# Please ensure that the '#{profile}' login profile has an associated aws_iam_user_login_profile with the #{resource_id} user in terraform configuration."
            end

            commands << '# Import the policy attachments (managed policies):' if Array(managed_policy_arn).any?
            Array(managed_policy_arn).each do |policy|
              commands << "# Please ensure that the '#{policy}' managed policy has an associated aws_iam_user_policy_attachment with the #{resource_id} user in terraform configuration."
            end

            commands << '# Associate user with groups:' if Array(group).any?
            Array(group).each do |group_name|
              commands << "# Please ensure that the #{resource_id} user is associated with the '#{group_name}' group in terraform configuration."
            end

            commands
          end

          def to_hcl_json(*)
            resources = []
            actual_user_name = user_name || (stack.resources[name] && stack.resources[name].physical_resource_id)
            resources << {
              aws_iam_user: {
                name.underscore => {
                  name: actual_user_name,
                  path: path,
                }
              }
            }

            { resource: resources }.to_json
          end
        end
      end
    end
  end
end
