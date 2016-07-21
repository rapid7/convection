# Convection Stacks
**NOTE**: Examples in this file can be found in `example/stacks`.

### Defining a stack
Defining a stack is as simple as a few lines of Ruby:

```ruby
# templates/vpc.rb
require 'convection'

module Templates
  VPC = Convection.template do
    description 'EC2 VPC Test Template'

    ec2_vpc 'TargetVPC' do
      network '10.10.10.0/23'
    end
  end
end
```

### Using a defined stack
```ruby
# Cloudfile
require_relative './templates/vpc.rb'

user = ENV['USER'] || 'anon'
name "#{user}-demo-cloud"
region 'us-east-1'

stack 'vpc', Templates::VPC
```

Once evaluated by Convection stacks will be represented as CloudFormation JSON.

### Defining a task to execute on a stack
A stack has the following life-cycle phases:

1. Before creation (`before_create_task`)
2. After creation (`after_create_task`)
3. Before being updated (`before_update_task`)
4. After being updated (`after_update_task`)
5. Before deletion (`before_delete_task`)
6. After deletion (`after_delete_task`)

To define tasks on a stack (using the `VPC` stack defined above for example):

```ruby
# tasks/lookup_vpc_task.rb
module Tasks
  class LookupVpcTask
    # REQUIRED: Convection expects tasks to respond to #call.
    def call(stack)
      @vpc_id = stack.get('vpc', 'id')
      @result = vpc_found?
    end

    # REQUIRED: Convection expects tasks to respond to #success?.
    def success?
      @result
    end

    # OPTIONAL: Convection emits the task as `task.to_s` in certain log messages.
    def to_s
      return 'VPC lookup' unless @vpc_id

      "VPC lookup of #{@vpc_id.inspect}"
    end

    private

    def vpc_found?
      true # XXX: This could be a call to the aws-sdk APIs.
    end
  end
end
```

You would then change your Cloudfile to give the optional configuration block to the stack declaration:
```ruby
# Cloudfile
stack 'vpc', Templates::VPC do
  after_create_task Tasks::LookupVpcTask.new
  after_update_task Tasks::LookupVpcTask.new
end
```
