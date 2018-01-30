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

          def additional_hcl_files(module_path: 'root')
            module_prefix = module_path.tr('.', '-') if module_path == 'root'
            result = {}

            user = user_name
            user ||= stack.resources[name] && stack.resources[name].physical_resource_id
            result["#{stack._original_region}-#{stack._original_cloud}-#{name.underscore}.tf.json"] = {
              module: [{
                name.underscore => {
                  source: _terraform_module_flag_to_dir(module_path),
                  managed_policy_arns: managed_policy_arn,
                  name: user,
                  path: path
                }
              }]
            }

            result["#{module_prefix}#{name.underscore}-variables.tf.json"] = {
              variable: [
                { managed_policy_arns: { description: 'A list of ARNs for managed policies to attach to this user.', default: [] } },
                { name: { description: 'The name of the user' } },
                { path: { description: 'The path for the IAM user', path: '/' } }
              ]
            }

            result["#{module_prefix}#{name.underscore}-user.tf.json"] = {
              resource: [
                {
                  aws_iam_user: {
                    name.underscore => {
                      name: '${var.name}',
                      path: '${var.path}'
                    }
                  }
                }
              ]
            }

            policy_resources = policies.map do |policy|
              {
                aws_iam_user_policy: {
                  policy.name.underscore => {
                    name: policy.name,
                    policy: policy.render.to_json,
                    user: "${aws_iam_user.#{name.underscore}.id}"
                  }
                }
              }
            end
            policy_resources << {
              aws_iam_user_policy_attachment: {
                "#{name.underscore}_managed" => {
                  count: managed_policy_arn.count,
                  user: "${aws_iam_user.#{name.underscore}.id}",
                  policy_arn: '${element(var.managed_policy_arns, count.index)}'
                }
              }
            }
            result["#{module_prefix}#{name.underscore}-policy.tf.json"] = { resource: policy_resources }

            result
          end
        end
      end
    end
  end
end
