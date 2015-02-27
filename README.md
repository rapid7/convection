# Convection
_A fully generic, modular DSL for AWS CloudFormation_

This gem aims to provide a reusable model for AWS CloudFormation in Ruby. It exposes a DSL for template definition, and a simple, decoupled abstraction of a CloudFormation Stack to compile and apply templates.

## Version 0.0.1
This is an Alpha release. It is still lacking functionality and testing. We plan to develop/improve features as we begin to use it for our own deployments in the coming months. PRs welcome.

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

## Create a new instance of Convection::Model::Template
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
  ## supported by CloudFormation: See http://docs.aws.amazon.com/\
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

Not implemented yet.

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
 * fn_ref(resource)

```ruby
ec2_instance "TestInstanceFoo#{ i }" do
  image_id find_in_map('RegionalAMIs', fn_ref('AWS::Region'), 'hvm')
  instance_type 'm3.medium'
  key_name find_in_map('RegionalKeys', fn_ref('AWS::Region'), 'test')
  security_group fn_ref('LousySecurityGroup')
  subnet fn_ref("TestSubnet")
end
```

## Stack Control
The `Stack` class provides a state wrapper for CloudFormation Stacks. It tracks the state of the managed stack, and creates/updates accordingly. `Stack` is also region-aware, and can be used within a template to define resources that depend upon availability-zones or other region-specific neuances that cannot be represented as maps or require iteration.

### Class `Convection::Control::Stack`
* `.new(name, template, options = {})`
  * _name_ CloudFormation Stack name
  * _template_ Instance of Convection::Model::Template
  * _options_ - Hash
    * _region_ - AWS region, format `us-east-1`. Default us-east-1
    * _credentials_ - Optional instance of AWS::Credentials. See the [AWS-SDK Documentation](http://docs.aws.amazon.com/sdkforruby/api/frames.html)
    * _parameters_ - Stack parameters, as a `Hash` of `{ key => value }`
    * _tags_ - Stack tags, as a `Hash` of `{ key => value }`
    * _on_failure_ - Create failure action. Default `DELETE`
    * _capabilities_ - See the [AWS-SDK Documentation](http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Client.html#create_stack-instance_method)
    * Additional options will be passed directly to `create_stack` and `update_stack`

* `#status` - Returns the stack status
* `#exist?` - Returns true if the stack exists and is not in a DELETED state
* `#complete?`
* `#rollback?`
* `#fail?`
* `#render` - Populates the provided template with any environment data included in the stack (e.g. availability zones). Returns a `Hash`
* `#to_json` - Render template and transofrm to a pretty-generated JSON `String`
* `#apply` - Renter template and create/update CloudFormation Stack
* `#delete` - Delete CloudFormation Stack
* `#availability_zones(&block)` - Return an array of strings representing the region's availability zones. Provided codeblock will be called for each AZ.

## Futures
*

## License
_Copyright (c) 2015 John Manero, Rapid7 LLC._

```
MIT License
===========

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

```
