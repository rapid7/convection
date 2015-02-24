#!/usr/bin/env ruby
require 'convection'

sqs_template = Convection.template do
  description 'Testing SQS bucket definition'

  sqs_queue 'TestQueue' do
    message_retention_period '345600'
    queue_name 'testQueueName'
    visibility_timeout '120'
  end
end

puts sqs_template.to_json
# puts Convection.stack('SQSTestQueue', sqs_template, :region => 'us-west-1').apply
