#!/usr/bin/env ruby
# $LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'convection'

test_template = Convection.template do
  description 'This is a test stack generated with Convection'

  parameter 'InstanceSize' do
    type 'String'
    description 'Instance Size'
    default 'm3.medium'

    allow 'm3.medium'
    allow 'm3.large'
    allow 'm3.xlarge'
  end

  mapping 'RegionalAMIs' do
    item 'us-east-1', 'hvm', 'ami-76e27e1e'
    item 'us-west-1', 'hvm', 'ami-d5180890'
    item 'us-east-1', 'pv', 'ami-64e27e0c'
    item 'us-west-1', 'pv', 'ami-c5180880'
  end

  mapping 'RegionalKeys' do
    item 'us-east-1', 'test', 'cf-test-keys'
    item 'us-west-1', 'test', 'cf-test-keys'
  end

  ## Define the VPC
  ec2_vpc 'TargetVPC' do
    network '100.65.0.0/18'
    subnet_length 25

    ## Add an InternetGateway
    vpc_gateway = add_internet_gateway

    ## Add a default routing table
    public_table = add_route_table 'Public' do
      route 'Default' do
        destination '0.0.0.0/0'
        gateway vpc_gateway
      end
    end

    ## Define Subnets and Insatnces in each availability zone
    stack.availability_zones do |zone, i|
      add_subnet "Test#{ i }" do
        availability_zone zone
        associate_route_table public_table

        tag 'Service', 'Foo'
      end
    end

    tag 'Name', join('-', 'cf-test-vpc', fn_ref('AWS::StackName'))
  end

  ec2_security_group 'BetterSecurityGroup' do
    ingress_rule do
      cidr_ip '0.0.0.0/0'
      from 22
      to 22
      protocol 'TCP'
    end
    egress_rule do
      cidr_ip '0.0.0.0/0'
      from 0
      to 65_535
      protocol(-1)
    end

    description 'Allow SSH traffic from all of the places'
    vpc_id fn_ref('TargetVPC')

    tag 'Name', join('-', fn_ref('AWS::StackName'), 'BetterSecurityGroup')
  end
end

# puts test_template.render
# puts test_template.to_json

# stack_e1 = Convection.stack('TestStackE1B1', test_template, :region => 'us-east-1')
stack_w1 = Convection.stack('TestStackW1B2', test_template, :region => 'us-west-1')

# puts stack_e1.status
# puts stack_e1.apply
puts stack_w1.to_json

puts "Status #{ stack_w1.status }"
puts stack_w1.apply
