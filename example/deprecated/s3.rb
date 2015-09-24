#!/usr/bin/env ruby
require 'convection'

s3_template = Convection.template do
  description 'Testing S3 bucket definition'

  s3_bucket 'TestBucket' do
    bucket_name 'convectiontestbucket'
  end
end

puts s3_template.to_json
# puts Convection.stack('S3TestStack', s3_template, :region => 'us-west-1').apply
