#!/usr/bin/env ruby
require 'convection'

test_iam_user_template = Convection.template do
  description 'This is an example of a stack representing IAM Users and Policies.'

  parameter 'Path' do
    type 'String'
    default '/'
  end

  iam_policy 'UserPolicy' do
    policy_name 'NewPolicy'
    user fn_ref(:NewUser)

    policy(
      :Statement => [{
        :Effect => 'Allow',
        :Action => ['s3:GetObject'],
        :Resource => ['arn:aws:s3:::some.bucket.name.here/*']
      }]
    )
  end

  iam_role 'NewUser' do
    path fn_ref(:Path)
  end
end

puts test_iam_user_template.to_json
# puts Convection.stack('IAMTestStack', test_iam_user_template, :region => 'us-west-1').apply
