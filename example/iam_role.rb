#!/usr/bin/env ruby
# $LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'convection'

##
# This is a quick example of building out a cloudformation template without
# extending the underlying DSL.
#
# The reason could be anything from the inability to extend the dsl to a feature
# in AWS has been made availalble but the DSL will be complex - so this is a
# quick way to get access to those features.
##

test_iam_role_template = Convection.template do
  description 'This is an example of a stack representing IAM Roles and Policies.'

  parameter 'Path' do
    type 'String'
    default '/'
  end

  iam_policy 'RolePolicy' do
    name 'NewPolicy'
    role fn_ref(:NewRole)

    policy(
      :Statement => [{
        :Effect => 'Allow',
        :Action => ['s3:GetObject'],
        :Resource => ['arn:aws:s3:::some.bucket.name.here/*']
      }]
    )
  end

  iam_role 'NewRole' do
    path fn_ref(:Path)

    # EC2 Instance Role
    trust_relationship(
      :Statement => [{
        :Effect => 'Allow',
        :Principal => {
          :Service => 'ec2.amazonaws.com'
        },
        :Action => 'sts:AssumeRole'
      }]
    )
  end
end

puts test_iam_role_template.to_json
# puts Convection.stack('IAMTestStack', test_iam_role_template, :region => 'us-west-1').apply
