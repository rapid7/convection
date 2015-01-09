$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
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

  ec2_vpc 'TargetVPC' do
    cidr_block '10.42.0.0/16'
    tag 'Name', 'test-vpc-foo'
  end

  ec2_security_group 'LousySecurityGroup' do
    ingress_rule do
      cidr_ip '0.0.0.0/0'
      from 0
      to 65_535
      protocol(-1)
    end
    egress_rule do
      cidr_ip '0.0.0.0/0'
      from 0
      to 65_535
      protocol(-1)
    end

    description 'Allow traffic from all of the places'
    vpc_id ref('TargetVPC')

    tag 'Name', join('-', 'LousySecurityGroup', ref('AWS::StackName'))
  end

  availability_zones do |az, i|
    ec2_subnet "TestSubnet#{ i }" do
      availability_zone az
      cidr_block "10.42.#{ i }.0/24"
      vpc_id ref('TargetVPC')

      tag 'Name', "Test-#{ az }"
      tag 'Service', 'Foo'
    end

    ec2_instance "TestInstanceFoo#{ i }" do
      image_id find_in_map('RegionalAMIs', ref('AWS::Region'), 'hvm')
      instance_type ref('InstanceSize')
      key_name find_in_map('RegionalKeys', ref('AWS::Region'), 'test')
      security_group ref('LousySecurityGroup')
      subnet ref("TestSubnet#{ i }")

      tag 'Service', 'Foo'
      tag 'Version', '0.0.1'
    end

    output "TestInstanceFoo#{ i }" do
      description 'Instance address'
      value get_att("TestInstanceFoo#{ i }", 'PrivateIp')
    end
  end
end

puts test_template.to_json

# Convection.stack('TestStackE1', test_template, :region => 'us-east-1').apply
# Convection.stack('TestStackW1', test_template, :region => 'us-west-1').apply
