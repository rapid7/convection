#!/usr/bin/env ruby
require 'convection'

test_iam_group_template = Convection.template do
  description 'This is an example of a stack representing IAM Groups and Policies.'

  parameter 'Path' do
    type 'String'
    default '/'
  end

  iam_policy 'GroupPolicy' do
    policy_name 'NewPolicy'
    group fn_ref(:NewGroup)

    policy(
      :Statement => [{
        :Effect => 'Allow',
        :Action => ['s3:GetObject'],
        :Resource => ['arn:aws:s3:::some.bucket.name.here/*']
      }]
    )
  end

  iam_group 'NewGroup' do
    path fn_ref(:Path)
  end
end

puts test_iam_group_template.to_json
# puts Convection.stack('IAMTestStack', test_iam_group_template, :region => 'us-west-1').apply
