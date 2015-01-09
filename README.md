# Convection
_A fully generic, modular DSL for AWS CloudFormation_

This gem aims to provide a reusable model for AWS CloudFormation in Ruby. It exposes a DSL for template definition, and a simple, decoupled abstraction of a CloudFormation Stack to compile and apply templates.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'convection'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install convection

## Template DSL
The core DSL provides all of the available JSON primatives of CloudFormation in the form of ruby methods. These primatives are used to compose higher-order methods for commonly used definitions:

```ruby
require 'convection'

## Define a
Convection.template do
  description 'An example template'

  parameter 'InstanceSize' do
    type 'String'
    description 'Instance Size'
    default 'm3.medium'

    allow 'm3.medium'
    allow 'm3.large'
    allow 'm3.xlarge'
  end

  ## The `resource` method can be used to define any resource
  ## supported by Cloudformation: See http://docs.aws.amazon.com/\
  ## AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html
  resource 'AnEC2Instance' do
    type 'AWS::EC2::Instance'
    property 'AvailabilityZone', 'us-east-1a'
    property 'ImageId', 'ami-76e27e1e' ## Ubuntu 14.04 hvm:ebs
    property 'KeyName', 'test'
    property 'SecurityGroupIds', ['sg-dd733c41', 'sg-dd738df3']
    property 'Tags', [{
      'Key' => 'Name',
      'Value' => 'test-1'
    }]

    property 'DisableApiTermination', false
  end

  ## `ec2_instnce` extends `resource`. The following results in JSON
  ## identical to that of Resource[AnEC2Instance]
  ec2_instance 'AnOtherInstance' do
    availability_zone 'us-east-1a'
    image_id 'ami-76e27e1e'
    key_name 'test'

    security_group 'sg-dd733c41'
    security_group 'sg-dd738df3'

    tag 'Name', 'test-2'

    ## All of the methods of the `resource` primative are available in
    ## its children:
    property 'DisableApiTermination', false
  end
end.to_json
```

### Parameters
http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html

```ruby
parameter 'InstanceType' do
  type 'String'
  description 'Set the thing\'s instance flavor'
  default 'm3.medium'

  allow 'm3.medium'
  allow 'm3.large'
  allow 'm3.xlarge'
end
```

### Mappings
http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/mappings-section-structure.html

```ruby
mapping 'RegionalAMIs' do
  item 'us-east-1', 'hvm', 'ami-76e27e1e'
  item 'us-west-1', 'hvm', 'ami-d5180890'
  item 'us-east-1', 'pv', 'ami-64e27e0c'
  item 'us-west-1', 'pv', 'ami-c5180880'
end
```

### Conditions
http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/conditions-section-structure.html

TODO...

### Resources
http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/resources-section-structure.html

```ruby
resource 'AnInstance' do
  type 'AWS::EC2::Instance'

  ## Optional condition reference
  condition 'SomeCondition'

  ## Add Resource Properties
  property 'AvailabilityZone', 'us-east-1a'
  property 'ImageId', 'ami-76e27e1e' ## Ubuntu 14.04 hvm:ebs
  property 'KeyName', 'test'
  ...
end
```

### Outputs
http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html

```ruby
output 'SomeName' do
  description 'An Important Attribute'
  value get_att('Resource', 'Attribute')

  ## Optional condition reference
  condition 'SomeCondition'
end
```

### Intrinsic Functions
http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html

All intrinsic functions are available as helper methods:

 * base64(content)
 * fn_and(conditions...)
 * fn_equals(value_1, value_2)
 * fn_if(condition, value_true, value_false)
 * fn_not(condition)
 * fn_or(conditions...)
 * find_in_map(map_name, key_1, key_2)
 * get_att(resource, attr_name)
 * get_azs(region)
 * join(delimiter, values...)
 * select(index, objects...)
 * ref(resource)

```ruby
ec2_instance "TestInstanceFoo#{ i }" do
  image_id find_in_map('RegionalAMIs', ref('AWS::Region'), 'hvm')
  instance_type 'm3.medium'
  key_name find_in_map('RegionalKeys', ref('AWS::Region'), 'test')
  security_group ref('LousySecurityGroup')
  subnet ref("TestSubnet")
end
```

## Stack Control
