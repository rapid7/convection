# Creating a custom resource collection
**NOTE**: Examples in this file can be found in `example/web-service-resource-collection`.

This guide will walk you through creating a custom resource collection.

For the purpose of this guide we'll create a resource collection to provision a web server listening on port 80 with security group ingress rules to only allow specific CIDR ranges.

## Attach your custom resource collection to the Template DSL
The below code snippet does the following:
* Defines `WebService` as a subclass of `Convection::Model::Template::ResourceCollection` (this provides a standard initialize function and mixins in convection helper functions).
* Defines `Template#web_service` which can later be called in the Convection template configuration.

```ruby
class WebService < Convection::Model::Template::ResourceCollection
  # Attach this class to the Template DSL with the method name "web_service".
  attach_to_dsl(:web_service)
end
```

## Override `ResourceCollection#execute`
When rendering resource collections convection internally calls `#run_definition` to resolve the configuration block passed in during template definition. After this call `#execute` is called. This method should be overridden for resource collections to call other [basic] convection resources.

```ruby
class WebService < Convection::Model::Template::ResourceCollection
  # ...

  def execute
    # Preserve scope by exposing a local "web_service" variable.
    web_service = self
    generate_security_groups(web_service)
    generate_ec2_instance(web_service)
  end

  def generate_ec2_instance(web_service)
    # TODO: Actually generate the ec2 instance resource!
  end

  def generate_security_groups(web_service)
    # TODO: Actually generate the ec2 security group resource!
  end
end
```

### Generating a security group for our web service
The below code can be used to generate a security group with a few tags and ingress rules defined for TCP over port 80 on any CIDR range in a CSV list from the `ALLOWED_CIDR_RANGES` environment variable.

```ruby
def cidr_ranges
  return ENV['ALLOWED_CIDR_RANGES'].split(/[, ]+/) if ENV.key?('ALLOWED_CIDR_RANGES')

  raise ArgumentError, "You must export $ALLOWED_CIDR_RANGES to diff/converge #{stack.cloud_name}."
end

def generate_security_groups(web_service)
  ec2_security_group "#{web_service.name}SecurityGroup" do
    description "EC2 Security Group for the #{web_service.name} web service."

    web_service.cidr_ranges.each do |range|
      ingress_rule(:tcp, 80, range)
    end

    tag 'Name', "sg-#{web_service.name}-#{stack.cloud}".downcase
    tag 'Service', web_service.name
    tag 'Stack', stack.cloud

    with_output
  end
end
```

### Generating a web server running on port 80
#### Create an EC2 instance
##### Support defining the image ID and instance user data via the template DSL
```ruby
class WebService < Convection::Model::Template::ResourceCollection
  # ...

  attribute :ec2_instance_image_id
  attribute :user_data
end
```

##### Generate the EC2 instance resource
```ruby
def generate_ec2_instance(web_service)
  ec2_instance "#{name}Frontend" do
    image_id web_service.ec2_instance_image_id
    security_group fn_ref("#{web_service.name}SecurityGroup")

    tag 'Name', "#{web_service.name}Frontend"
    tag 'Stack', stack.cloud

    user_data base64(web_service.user_data)

    with_output 'Hostname', get_att(name, 'PublicDnsName') do
      description 'The public hostname of this web service.'
    end

    with_output 'HttpEndpoint', join('', 'http://', get_att(name, 'PublicDnsName')) do
      description 'The URL to visit this web service at.'
    end
  end
end
```

## Define your convection template using your resource collection
### Call your custom resource like any other resource
```ruby
require_relative '../path/to/your/resources/web_service.rb'

EXAMPLE_DOT_ORG = Convection.template do
  description 'An example website to demonstrate using custom resource collections.'

  web_service 'ExampleDotOrg' do
    # Set the instance ID attribute so the instance can be converged.
    ec2_instance_image_id 'ami-45026036' # ubuntu <3!

    user_data <<~USER_DATA
      #!/bin/bash
      echo 'Hello World!'
    USER_DATA
  end
end
```

### Set the user data up as a shell script to install nginx
A quick and simple way to expose an HTTP server on port 80 is to install nginx.

You can do this with the bash script embedded as user data in your template like so:
```ruby
user_data <<~USER_DATA
  #!/bin/bash
  apt-get update
  apt-get install -y unzip curl nginx
  service nginx start
  update-rc.d nginx defaults
USER_DATA
```

## Converge your template
1. Export your AWS credentials.
2. Export the `ALLOWED_CIDR_RANGES` we use for setting our ingress rules.
  * This should be set to your external IP address so the instance allows connections from your machine.
3. Run `convection diff` to show what will be converged.
4. Run `convection converge` to deploy your stack.
5. Open the stack outputs section CloudFormation for this stack.
6. Click on the HttpEndpoint value.
7. Look at the "Welcome to nginx!" page.
