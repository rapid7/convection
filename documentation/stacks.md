# Convection Stacks
### Defining a stack
Defining a stack is as simple as a few lines of Ruby:

```ruby
# vpc.rb
VPC = Convection.template do
  description 'EC2 VPC Test Template'

  ec2_vpc 'TargetVPC' do
    network '10.0.0.0'
    subnet_length 24
    enable_dns
  end
end
```

```ruby
# Cloudfile
stack 'vpc', VPC
```

Once evaluated by Convection stacks will be represented as CloudFormation JSON.

### Defining a task to execute on a stack
A stack has the following life-cycle phases:

1. Before creation (`before_create`)
2. After creation (`after_create`)
3. Before being updated (`before_update`)
4. After being updated (`after_update`)
5. Before deletion (`before_delete`)
6. After deletion (`after_delete`)

To define tasks on a stack (using the `VPC` stack defined above for example):

```ruby
# lookup_vpc_task.rb
class LookupVpcTask
  def initialize(wait_seconds)
    @wait_seconds = wait_seconds
  end

  # REQUIRED: Convection expects Tasks to respond to #call.
  def call(stack)
    sleep wait_seconds # Do not actually sleep like this. This is just for an example.
    id = stack.get('vpc', 'id')
    @result = vpc_found?(id)
  end

  # REQUIRED: Convection expects Tasks to respond to #success?.
  def success?
    @result
  end

  private

  def vpc_found?(id)
    true
  end
end
```

You would then change your Cloudfile to give the optional configuration block to the stack declaration:
```ruby
# Cloudfile
stack 'vpc', VPC do
  after_create_task LookupVpcTask.new(300) # wait up to 5 minutes when looking for a new VPC
  after_update_task LookupVpcTask.new(60) # only wait 1 minute when looking for an existing VPC
end
```
