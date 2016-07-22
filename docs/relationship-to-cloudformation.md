# Relationship to CloudFormation
Convection builds on top of the [Amazon CloudFormation](https://aws.amazon.com/cloudformation/) resource managment tooling. Additionally it adds support for providing additional functionalities using thirdparty tools (AWS APIs or otherwise).

## Convection Stacks
A Convection Stack (see [Convection::Control::Stack][convection-stack-api]) acts as a Ruby wrapper for a CloudFormation stack. When `Convection::Control::Stack#to_json` is called it is rendered into the CloudFormation template format to be pushed to CloudFormation.

Convection adds the notion of state by comparing the remote stack (from CloudFormation) and local stack (rendered from your Ruby DSL template).

## Cloudfiles
A Cloudfile is used to connect a series of stacks. A Cloudfile requires a name and a region. You can specify multiple stacks to converge for a given "cloud".

### Example
You may have multiple Cloudfiles for your different regions or for your test/prod environments like so:

#### Environments
##### `clouds/test-0/Cloudfile`
```ruby
name 'test-0'
region 'us-east-1'

# Mock RDS in the test environment for quicker turn around.
stack 'rds', Templates::MOCK_RDS
```

##### `clouds/prod-0/Cloudfile`
```ruby
name 'prod-0'
region 'us-east-1'

stack 'rds', Templates::RDS
```

#### Regions
##### `clouds/us-east-1/Cloudfile`
```ruby
name 'prod-0'
region 'us-east-1'

stack 'cdn', Templates::CDN
```

##### `clouds/us-west-1/Cloudfile`
```ruby
name 'prod-1'
region 'us-west-1'

# Instead of re-creating a CDN per region create a "cdn" mirror in this region.
stack 'cdn', Templates::CDN_MIRROR
```

[convection-stack-api]: http://www.rubydoc.info/gems/convection/Convection/Control/Stack
