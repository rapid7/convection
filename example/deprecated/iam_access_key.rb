#!/usr/bin/env ruby
require 'convection'

test_iam_access_key_template = Convection.template do
  description 'This example creates a user an access keys for that user.'

  iam_user 'NewUser' do
    path 'new_user'
  end

  iam_access_key 'NewUserKey' do
    status 'Active'
    user_name fn_ref(:NewUser)
  end
end

puts test_iam_access_key_template.to_json
# puts Convection.stack('IAMTestStack', test_iam_access_key_template, :region => 'us-west-1').apply
