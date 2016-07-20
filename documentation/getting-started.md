# Getting Started #

This guide walks you through the creation of a Convection template that matches
up with one of [Amazon's VPC Wizard Scenarios][vpc2], creating a VPC with public
and private subnets.

By the end of this guide you'll have the following resources in your Amazon
account

* A CloudFormation template describing everything in this guide
* A VPC with two subnets, one public, one private
* A NAT router so EC2 instances in the private subnet can reach the internet
* A security group for the NAT router so you can control access to it

To get started, create the following directory structure for your project. If your region is not us-east-1 then change that to your region. If you have multiple regions create multiple region folders each with their own cloud file.
```
my-convection-project/
├── clouds
│   └── us-east-1
└── templates
```
In the top level of your convection project create a file "Gemfile" with the following inside.
```ruby
gem 'convection'
```

In the us-east-1 folder open a new file named "Cloudfile" and put the following Ruby
```ruby
Dir.glob('./../../templates/**.rb') do |file|
  require_relative file
end

region 'us-east-1'
name 'convection-demo'
```

Cloudfiles are written using Convection's DSL. The "convection" gem defines
methods like `region` and `name`. The `region` method tells Convection where
AWS resources should be created. The `name` method provides a common identifier
for grouping AWS resources.

The core of Convection's DSL consists of two parts, templates and stacks.
Templates let you to describe AWS resources in a reusable fashion. Stacks are
instances of a template in Amazon. We're going to start by creating a template
and stack to define our VPC.

Update your Cloudfile to look like the one below.

```ruby
Dir.glob('./../../templates/**.rb') do |file|
  require_relative file
end

region 'us-east-1'
name 'convection-demo'

stack 'vpc', Templates::VPC
```
In the templates directory create a vpc.rb file and include the following in it.
```ruby
require 'convection'

module Templates
  VPC = Convection.template do
    description 'VPC with Public and Private Subnets (NAT)'

  end
end
```

The `template` method creates a Convection template. The `description` property
in the template maps to the "Description" property in a [CloudFormation template][cf-template].
Assigning the result of the `template` method to the `VPC` variable allows us to
pass the template to the `stack` method. The `stack` method defines a
CloudFormation stack in AWS.

This separation between the description of AWS resources (the template) and
the instantiation of those resources (the stack) makes Convection templates
flexible.

Now that we've got a Convection template, we can run Convection's diff command
to compare what's in our template with what's in Amazon. This is a new template,
so we should only see new resources being created.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .AWSTemplateFormatVersion: 2010-09-09
 create  .Description: VPC with Public and Private Subnets (NAT)
```

The first line of output tells us that Convection's comparing our "vpc" stack
with the remote CloudFormation stack in Amazon. Since this is a new stack,
Convection prints two more lines telling us it's going to create the stack and
give it a description.

Now that we know what Convection's going to do, we can ask it to check that
stack creation will succeed. To do that, we run Convection's validate command.

```text
$> convection validate vpc

Template format error: At least one Resources member must be defined.
```

The validate command takes a single argument, the name of the stack to validate.
We only have the "vpc" stack, so that's what we're validating. Convection
tells us that our template's not valid. We're missing a resource.

Since we're building a VPC with two subnets, let's add the VPC itself as a
resource. Our VPC will be of size /23 and use the CIDR block 10.10.10.0/23.

Update your vpc.rb template to look like the one below.

```ruby
require 'convection'

module Templates
  VPC = Convection.template do
    description 'VPC with Public and Private Subnets (NAT)'

    ec2_vpc 'DemoVPC' do
      network '10.10.10.0/23'
    end
  end
end
```

The `ec2_vpc` method defines an [AWS::EC2::VPC][cf-vpc] resource in
Convection. VPC resources require a CIDR block. We set the `network`
property in our template to the CIDR block we want our VPC to use. Now
we can validate our template.

```text
$> convection validate vpc

Template validated successfully
```

Our template's good, so we'll diff it again to see what's going to change.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .AWSTemplateFormatVersion: 2010-09-09
 create  .Description: VPC with Public and Private Subnets (NAT)
 create  .Resources.DemoVPC.Type: AWS::EC2::VPC
 create  .Resources.DemoVPC.Properties.CidrBlock: 10.10.10.0/23
```

That looks correct. Convection will create a VPC with a CIDR block of
10.10.10.0/23.  We can run Convection's converge command to create the VPC in
Amazon.

```text
$> convection converge

converge  Stack vpc
create_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack) User Initiated
create_in_progress  DemoVPC: (AWS::EC2::VPC)
create_in_progress  DemoVPC: (AWS::EC2::VPC) Resource creation Initiated
create_complete  DemoVPC: (AWS::EC2::VPC)
create_complete  convection-demo-vpc: (AWS::CloudFormation::Stack)
```

If we look at the Amazon web console, you can see Convection's created two
new things for us. There's a CloudFormation stack named "convection-demo-vpc"
and there's the actual VPC resource, which is currently unnamed.

We can name the VPC resource by tagging it. Setting the `tag` attribute on
the "DemoVPC" resource in Convection will add a tag to the resource. We'll use
a combination of the cloud name and the stack name as the tag for the VPC.

Update your vpc.rb template to look like the one below.

```ruby
require 'convection'

module Templates
  VPC = Convection.template do
    description 'VPC with Public and Private Subnets (NAT)'

    ec2_vpc 'DemoVPC' do
      network '10.10.10.0/23'
      tag 'Name', "#{stack.cloud}-#{stack.name}"
    end
  end
end
```

We're using a naming convection for resources that includes the cloud name and
the stack name. That makes it easy to look through the Amazon web console and
see which resources belong to which Convection managed clouds. Now we run
the diff command to see the changes Convection will apply.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .Resources.DemoVPC.Properties.Tags.0.Key: Name
 create  .Resources.DemoVPC.Properties.Tags.0.Value: convection-demo-vpc
```
To see what the cloud formation template for your vpc template would look like you can run `convection print vpc`.
This can help you verify that values referenced under the `stack` namespace are set correctly.

```json
$> convection print vpc
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "VPC with Public and Private Subnets (NAT)",
  "Parameters": {
  },
  "Mappings": {
  },
  "Conditions": {
  },
  "Resources": {
    "DemoVPC": {
      "Type": "AWS::EC2::VPC",
      "Properties": {
        "CidrBlock": "10.10.10.0/23",
        "Tags": [
          {
            "Key": "Name",
            "Value": "convection-demo-vpc"
          }
        ]
      }
    }
  },
  "Outputs": {
  }
}
```

Convection's going to add the "Name" tag to the "DemoVPC" resource. That's what
we want, so we can converge our template.

```text
$> convection converge

converge  Stack vpc
update_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack) User Initiated
update_in_progress  DemoVPC: (AWS::EC2::VPC)
update_complete  DemoVPC: (AWS::EC2::VPC)
update_complete_cleanup_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack)
update_complete  convection-demo-vpc: (AWS::CloudFormation::Stack)
```

Looking at the Amazon web console, we can see that our VPC is now named
"convection-demo-vpc".

## Creating a private subnet ##

The CIDR block for our VPC is 10.10.10/23. We'll set up a public subnet
with a CIDR block of 10.10.11.0/24 and a private subnet with a CIDR block of
10.10.10.0/24. Let's create the private subnet first.

Just like there's an `ec2_vpc` method in Convection for creating a VPC, there's
also an `ec2_subnet` method for creating a subnet. And like our VPC, our subnet
will have `network` and `tag` attributes.

Update your vpc.rb template to look like the one below.

```ruby
require 'convection'

module Templates
  VPC = Convection.template do
    description 'VPC with Public and Private Subnets (NAT)'

    ec2_vpc 'DemoVPC' do
      network '10.10.10.0/23'
      tag 'Name', "#{stack.cloud}-#{stack.name}"
    end

    ec2_subnet 'PrivateSubnet' do
      network '10.10.10.0/24'
      tag 'Name', "#{stack.cloud}-#{stack.name}-private"
    end

  end
end
```

We can run the diff command to see what Convection's going to create.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .Resources.PrivateSubnet.Type: AWS::EC2::Subnet
 create  .Resources.PrivateSubnet.Properties.CidrBlock: 10.10.10.0/24
 create  .Resources.PrivateSubnet.Properties.Tags.0.Key: Name
 create  .Resources.PrivateSubnet.Properties.Tags.0.Value: convection-demo-vpc-private
```

There's our new private subnet with its CIDR block and "Name" tag. If we look at
the documentation for the [AWS::EC2::Subnet][cf-subnet] resource, we
can see it has a required "VpcId" attribute. We can use the Convection's
`fn_ref` method to get the logical ID of our VPC resource and pass it in to the subnet.

Update your vpc.rb template to look like the one below.

```ruby
require 'convection'

module Templates
  VPC = Convection.template do
    description 'VPC with Public and Private Subnets (NAT)'

    ec2_vpc 'DemoVPC' do
      network '10.10.10.0/23'
      tag 'Name', "#{stack.cloud}-#{stack.name}"
    end

    ec2_subnet 'PrivateSubnet' do
      network '10.10.10.0/24'
      tag 'Name', "#{stack.cloud}-#{stack.name}-private"
      vpc fn_ref('DemoVPC')
    end

  end
end
```

Now we can diff the Cloudfile and see that the "VpcId" property's getting set
on our subnet.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .Resources.PrivateSubnet.Type: AWS::EC2::Subnet
 create  .Resources.PrivateSubnet.Properties.VpcId.Ref: DemoVPC
 create  .Resources.PrivateSubnet.Properties.CidrBlock: 10.10.10.0/24
 create  .Resources.PrivateSubnet.Properties.Tags.0.Key: Name
 create  .Resources.PrivateSubnet.Properties.Tags.0.Value: convection-demo-vpc-private
```

Let's converge the Cloudfile, and create a new private subnet in Amazon.

```text
$> convection converge

converge  Stack vpc
update_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack) User Initiated
create_in_progress  PrivateSubnet: (AWS::EC2::Subnet)
create_in_progress  PrivateSubnet: (AWS::EC2::Subnet) Resource creation Initiated
create_complete  PrivateSubnet: (AWS::EC2::Subnet)
update_complete_cleanup_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack)
update_complete  convection-demo-vpc: (AWS::CloudFormation::Stack)
```

## Creating a public subnet ##

Creating a public subnet is exactly the same as creating a private subnet.
Use the `ec2_subnet` method to create an [AWS::EC2::Subnet][cf-subnet]
resource and give it a CIDR block of 10.10.11.0/24. Insert the following convection code into your vpc.rb template to accomplish this.

```ruby
ec2_subnet 'PublicSubnet' do
  network '10.10.11.0/24'
  tag 'Name', "#{stack.cloud}-#{stack.name}-public"
  vpc fn_ref('DemoVPC')
end
```

Looking at the documentation for the [AWS::EC2::Subnet][cf-subnet]
resource, the major difference between a public and private subnet is
that Amazon assigns IP addresses to public subnets. Making a subnet public is
a matter of setting the "MapPublicIpOnLaunch" property to `true`.

Add the below line to your `PublicSubnet` block

```ruby
public_ips true
```

Your diff should contain your changes for the public subnet.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .Resources.PublicSubnet.Type: AWS::EC2::Subnet
 create  .Resources.PublicSubnet.Properties.VpcId.Ref: DemoVPC
 create  .Resources.PublicSubnet.Properties.CidrBlock: 10.10.11.0/24
 create  .Resources.PublicSubnet.Properties.MapPublicIpOnLaunch: true
 create  .Resources.PublicSubnet.Properties.Tags.0.Key: Name
 create  .Resources.PublicSubnet.Properties.Tags.0.Value: convection-demo-vpc-public
```

Convection says it will create our public subnet with the "MapPublicIpOnLaunch"
property set to `true`. It also doesn't show any changes to our private subnet.
That's what we expect, so we can converge our template.

```text
$> convection converge

converge  Stack vpc
update_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack) User Initiated
create_in_progress  PublicSubnet: (AWS::EC2::Subnet)
create_in_progress  PublicSubnet: (AWS::EC2::Subnet) Resource creation Initiated
create_complete  PublicSubnet: (AWS::EC2::Subnet)
update_complete_cleanup_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack)
update_complete  convection-demo-vpc: (AWS::CloudFormation::Stack)
```

If we look at our subnets in the Amazon web console, we can see the public
subnet has the "Auto-assign Public IP" attribute set to "yes" and the private
subnet has that value set to "no". Any EC2 instances we create in the public
subnet will automatically get public IP addresses.

## Create a security group for the NAT router ##

Our NAT router is going to live in the public subnet. However, we want to
restrict access so only EC2 instances in our private subnet can use it. We can
do this with a security group.

Convection provides an `ec2_security_group` method for creating security groups.
The [AWS::EC2::SecurityGroup][cf-security-group] resource requires a description
and a reference to our VPC. We can add the `ec2_security_group` method to our
Cloudfile with a `description` and `vpc` attribute to create a default security
group for our NAT router.

Add the below block to your vpc.rb template

```ruby
ec2_security_group 'NATSecurityGroup' do
  description 'NAT access for private subnet'
  vpc fn_ref('DemoVPC')
  tag 'Name', "#{stack.cloud}-#{stack.name}-nat-security-group"
end
```

We'll follow the same pattern we've used before. Diff the Convection template to
make sure it does what we expect, then converge it. This pattern of diffing then
converging is useful when paired with code reviews. You can make changes to a
template, diff it, then have the changes and diff reviewed before you converge.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .Resources.NATSecurityGroup.Type: AWS::EC2::SecurityGroup
 create  .Resources.NATSecurityGroup.Properties.GroupDescription: NAT access for private subnet
 create  .Resources.NATSecurityGroup.Properties.VpcId.Ref: DemoVPC
 create  .Resources.NATSecurityGroup.Properties.Tags.0.Key: Name
 create  .Resources.NATSecurityGroup.Properties.Tags.0.Value: convection-demo-vpc-nat-security-group
```

```text
$> convection converge

converge  Stack vpc
update_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack) User Initiated
create_in_progress  NATSecurityGroup: (AWS::EC2::SecurityGroup)
create_in_progress  NATSecurityGroup: (AWS::EC2::SecurityGroup) Resource creation Initiated
create_complete  NATSecurityGroup: (AWS::EC2::SecurityGroup)
update_complete_cleanup_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack)
update_complete  convection-demo-vpc: (AWS::CloudFormation::Stack)
```

Looking at our new security group in the Amazon web console, we can see it
doesn't have any inbound rules. Lets update our security group to allow inbound
web traffic from our private subnet.

Within the `ec2_security_group` method, Convection provides the `ingress_rule`
helper method for defining inbound rules. The method takes a traffic type, a
port number, and a block for setting the rule's `source` attribute.

Update the block in your `ec2_security_group` method to look like the one below.

```ruby
ec2_security_group 'NATSecurityGroup' do
  description 'NAT access for private subnet'
  vpc fn_ref('DemoVPC')
  tag 'Name', "#{stack.cloud}-#{stack.name}-nat-security-group"
  ingress_rule :tcp, 443 do
    source '10.10.10.0/24'
  end
  ingress_rule :tcp, 80 do
    source '10.10.10.0/24'
  end
end
```

This locks down our NAT router so it can only receive requests for web traffic
from our private subnet. Having ingress rules for ports 443 and 80 allows us to
handle both HTTPS and HTTP traffic.

By default, Amazon sets an outbound rule on our security group that allows all
traffic. Since our NAT router only handles web traffic, we can add egress rules
as well and lock down outbound requests. Convection has an `egress_rule` method
for setting output traffic rules. It has the same syntax as the `ingress_rule`
method.

Your vpc.rb template should now look like the one below.

```ruby
require 'convection'

module Templates
  VPC = Convection.template do
    description 'VPC with Public and Private Subnets (NAT)'

    ec2_vpc 'DemoVPC' do
      network '10.10.10.0/23'
      tag 'Name', "#{stack.cloud}-#{stack.name}"
    end

    ec2_subnet 'PrivateSubnet' do
      network '10.10.10.0/24'
      tag 'Name', "#{stack.cloud}-#{stack.name}-private"
      vpc fn_ref('DemoVPC')
    end

    ec2_subnet 'PublicSubnet' do
      network '10.10.11.0/24'
      tag 'Name', "#{stack.cloud}-#{stack.name}-public"
      vpc fn_ref('DemoVPC')
      public_ips true
    end

    ec2_security_group 'NATSecurityGroup' do
      description 'NAT access for private subnet'
      vpc fn_ref('DemoVPC')
      tag 'Name', "#{stack.cloud}-#{stack.name}-nat-security-group"
      ingress_rule :tcp, 443 do
        source '10.10.10.0/24'
      end
      ingress_rule :tcp, 80 do
        source '10.10.10.0/24'
      end
      egress_rule :tcp, 443 do
        source '0.0.0.0/0'
      end
      egress_rule :tcp, 80 do
        source '0.0.0.0/0'
      end
    end

  end
end
```

Our security group's locked down, so we can diff our template and see what
changes.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupIngress.0.IpProtocol: 6
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupIngress.0.FromPort: 443
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupIngress.0.ToPort: 443
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupIngress.0.CidrIp: 10.10.10.0/24
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupIngress.1.IpProtocol: 6
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupIngress.1.FromPort: 80
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupIngress.1.ToPort: 80
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupIngress.1.CidrIp: 10.10.10.0/24
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupEgress.0.IpProtocol: 6
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupEgress.0.FromPort: 443
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupEgress.0.ToPort: 443
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupEgress.0.CidrIp: 0.0.0.0/0
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupEgress.1.IpProtocol: 6
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupEgress.1.FromPort: 80
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupEgress.1.ToPort: 80
 create  .Resources.NATSecurityGroup.Properties.SecurityGroupEgress.1.CidrIp: 0.0.0.0/0
```

It's exactly what we expect. Looks like it's just the ingress and egress rules,
so we can converge the template and apply the changes.

```text
$> convection converge

converge  Stack vpc
update_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack) User Initiated
update_in_progress  NATSecurityGroup: (AWS::EC2::SecurityGroup)
update_complete  NATSecurityGroup: (AWS::EC2::SecurityGroup)
update_complete_cleanup_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack)
update_complete  convection-demo-vpc: (AWS::CloudFormation::Stack)
```

## Create the NAT router ##

Now that we've got our security group, we need to set up an EC2 instance that
will function as a NAT router. We'll be using one of [Amazon's pre-built NAT
images][nat-instance] since we don't need anything custom. Open up the Amazon
web console and search for AMIs with the string "amzn-ami-vpc-nat-pv" in their
name. The most recent one, from March 2015, has ID ami-c02b04a8.

The [AWS::EC2::Instance][cf-ec2] resource handles creating our
router instance from the given AMI. Since our router provides internet access,
it needs to be in the public subnet. We also need to disable source/destination
checking so it can perform network address translation. Finally, we'll make
sure the instance is in the security group we just created.

Update your vpc.rb template to look like the one below.

```ruby
require 'convection'

module Templates
  VPC = Convection.template do
    description 'VPC with Public and Private Subnets (NAT)'

    ec2_vpc 'DemoVPC' do
      network '10.10.10.0/23'
      tag 'Name', "#{stack.cloud}-#{stack.name}"
    end

    ec2_subnet 'PrivateSubnet' do
      network '10.10.10.0/24'
      tag 'Name', "#{stack.cloud}-#{stack.name}-private"
      vpc fn_ref('DemoVPC')
    end

    ec2_subnet 'PublicSubnet' do
      network '10.10.11.0/24'
      tag 'Name', "#{stack.cloud}-#{stack.name}-public"
      vpc fn_ref('DemoVPC')
      public_ips true
    end

    ec2_security_group 'NATSecurityGroup' do
      description 'NAT access for private subnet'
      vpc fn_ref('DemoVPC')
      tag 'Name', "#{stack.cloud}-#{stack.name}-nat-security-group"
      ingress_rule :tcp, 443 do
        source '10.10.10.0/24'
      end
      ingress_rule :tcp, 80 do
        source '10.10.10.0/24'
      end
      egress_rule :tcp, 443 do
        source '0.0.0.0/0'
      end
      egress_rule :tcp, 80 do
        source '0.0.0.0/0'
      end
    end

    ec2_instance 'NATInstance' do
      tag 'Name', "#{stack.cloud}-#{stack.name}-nat"
      image_id 'ami-c02b04a8'
      subnet fn_ref('PublicSubnet')
      security_group fn_ref('NATSecurityGroup')
      src_dst_checks false
    end

  end
end
```

We can diff our template to see what's going to change.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .Resources.NATInstance.Type: AWS::EC2::Instance
 create  .Resources.NATInstance.Properties.ImageId: ami-c02b04a8
 create  .Resources.NATInstance.Properties.SubnetId.Ref: PublicSubnet
 create  .Resources.NATInstance.Properties.SecurityGroupIds.0.Ref: NATSecurityGroup
 delete  .Resources.NATInstance.Properties.SourceDestCheck
 create  .Resources.NATInstance.Properties.Tags.0.Key: Name
 create  .Resources.NATInstance.Properties.Tags.0.Value: convection-demo-vpc-nat
```

It's just our NAT router that's new, so let's converge it.

```text
$> convection converge

converge  Stack vpc
update_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack) User Initiated
create_in_progress  NATInstance: (AWS::EC2::Instance)
create_in_progress  NATInstance: (AWS::EC2::Instance) Resource creation Initiated
create_complete  NATInstance: (AWS::EC2::Instance)
update_complete_cleanup_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack)
update_complete  convection-demo-vpc: (AWS::CloudFormation::Stack)
```
## Create a route table for the public subnet ##

In order for instances in our public subnet to reach the internet, our VPC needs
an [AWS::EC2::InternetGateway][cf-internet-gateway] resource. Using stock
CloudFormation, we'd create the gateway and wire it up to to our VPC with an
[AWS::EC2::VPCGatewayAttachment][cf-gateway-attachment]. We'd also need a with
[AWS::EC2::RouteTable][cf-route-table] resource for the gateway with a
default [AWS::EC2::Route][cf-route] resource that lets it connect to the
world.

We could use Convection to create each of those resources. However, there's a
simpler way. Convection provides an `add_route_table` method that can generate
an internet gateway and wire it up to our VPC.

Update your `ec2_vpc` block to look like the one below. NOTE we added `enable_dns` and `add_route_table`.
```ruby
  ec2_vpc 'DemoVPC' do
    network '10.10.10.0/23'
    tag 'Name', "#{stack.cloud}-#{stack.name}"
    enable_dns true
    add_route_table 'InternetGateway', gateway_route: true
  end
```

Diffing our template, we can see our VPC will get a Route, RouteTable,
InternetGateway, and InternetGateway attachment. The route lets the internet
gateway talk to the world, which is exactly what we want. Notice that we're
also enabling DNS support and hostnames on our VPC.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .Resources.DemoVPCTableInternetGateway.Type: AWS::EC2::RouteTable
 create  .Resources.DemoVPCTableInternetGateway.Properties.VpcId.Ref: DemoVPC
 create  .Resources.DemoVPCTableInternetGateway.Properties.Tags.0.Key: Name
 create  .Resources.DemoVPCTableInternetGateway.Properties.Tags.0.Value: DemoVPCTableInternetGateway
 create  .Resources.DemoVPCIGVPCAttachmentDemoVPC.Type: AWS::EC2::VPCGatewayAttachment
 create  .Resources.DemoVPCIGVPCAttachmentDemoVPC.Properties.VpcId.Ref: DemoVPC
 create  .Resources.DemoVPCIGVPCAttachmentDemoVPC.Properties.InternetGatewayId.Ref: DemoVPCIG
 create  .Resources.DemoVPCIG.Type: AWS::EC2::InternetGateway
 create  .Resources.DemoVPCIG.Properties.Tags.0.Key: Name
 create  .Resources.DemoVPCIG.Properties.Tags.0.Value: DemoVPCInternetGateway
 create  .Resources.DemoVPCTableInternetGatewayRouteDefault.Type: AWS::EC2::Route
 create  .Resources.DemoVPCTableInternetGatewayRouteDefault.Properties.RouteTableId.Ref: DemoVPCTableInternetGateway
 create  .Resources.DemoVPCTableInternetGatewayRouteDefault.Properties.DestinationCidrBlock: 0.0.0.0/0
 create  .Resources.DemoVPCTableInternetGatewayRouteDefault.Properties.GatewayId.Ref: DemoVPCIG
 create  .Resources.DemoVPC.Properties.EnableDnsSupport: true
 create  .Resources.DemoVPC.Properties.EnableDnsHostnames: true
```

Everything looks good, so we can converge the stack and create new resources.

```text
$> convection converge

converge  Stack vpc
update_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack) User Initiated
create_in_progress  DemoVPCIG: (AWS::EC2::InternetGateway)
create_in_progress  DemoVPCIG: (AWS::EC2::InternetGateway) Resource creation Initiated
update_in_progress  DemoVPC: (AWS::EC2::VPC)
update_complete  DemoVPC: (AWS::EC2::VPC)
create_in_progress  DemoVPCTableInternetGateway: (AWS::EC2::RouteTable)
create_in_progress  DemoVPCTableInternetGateway: (AWS::EC2::RouteTable) Resource creation Initiated
create_complete  DemoVPCTableInternetGateway: (AWS::EC2::RouteTable)
create_complete  DemoVPCIG: (AWS::EC2::InternetGateway)
create_in_progress  DemoVPCTableInternetGatewayRouteDefault: (AWS::EC2::Route)
create_in_progress  DemoVPCIGVPCAttachmentDemoVPC: (AWS::EC2::VPCGatewayAttachment)
create_in_progress  DemoVPCIGVPCAttachmentDemoVPC: (AWS::EC2::VPCGatewayAttachment) Resource creation Initiated
create_in_progress  DemoVPCTableInternetGatewayRouteDefault: (AWS::EC2::Route) Resource creation Initiated
create_complete  DemoVPCIGVPCAttachmentDemoVPC: (AWS::EC2::VPCGatewayAttachment)
create_complete  DemoVPCTableInternetGatewayRouteDefault: (AWS::EC2::Route)
update_complete_cleanup_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack)
update_complete  convection-demo-vpc: (AWS::CloudFormation::Stack)
```
Now that we have an internet gateway, we need to associate its route table with
the public subnet. We can create an
[AWS::EC2::SubnetRouteTableAssociation][cf-association] resource to do that. The
`ec2_subnet_route_table_association` method in Convection will do that.

Add the below block to the bottom of your vpc.rb template below your `ec2_instance 'NATInstance'` block.

```ruby
ec2_subnet_route_table_association 'DemoVPCRouteTable' do
  route_table fn_ref('DemoVPCTableInternetGateway')
  subnet fn_ref('PublicSubnet')
end
```

Where did the reference to "DemoVPCTableInternetGateway" come from? Convection
took the name of our VPC "DemoVPC", added "Table" to it, and appended the name
of our route table "InternetGateway". Looking at the output from our previous
converge shows the "DemoVPCTableInternetGateway" resource being created. Use
diff to check that the route table association will be created.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .Resources.DemoVPCRouteTable.Type: AWS::EC2::SubnetRouteTableAssociation
 create  .Resources.DemoVPCRouteTable.Properties.RouteTableId.Ref: DemoVPCTableInternetGateway
 create  .Resources.DemoVPCRouteTable.Properties.SubnetId.Ref: PublicSubnet
```

Now go ahead and converge the stack.

```text
$> convection converge

converge  Stack vpc
update_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack) User Initiated
create_in_progress  DemoVPCRouteTable: (AWS::EC2::SubnetRouteTableAssociation)
create_in_progress  DemoVPCRouteTable: (AWS::EC2::SubnetRouteTableAssociation) Resource creation Initiated
create_complete  DemoVPCRouteTable: (AWS::EC2::SubnetRouteTableAssociation)
update_complete_cleanup_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack)
update_complete  convection-demo-vpc: (AWS::CloudFormation::Stack)
```

## Create a route table for the private subnet ##

Just like we created a route table for the public subnet, we now need a route
table for the private subnet. Our route table will reference our VPC and define
a single route for all traffic from our private instances through our NAT.
Convection's `ec2_route_table` method can be used to explicitly create a route
table.

Add the below block to the bottom of your vpc.rb template

```ruby
ec2_route_table 'PrivateRouteTable' do
  vpc fn_ref('DemoVPC')
  route 'PrivateRoute' do
    destination '0.0.0.0/0'
    instance fn_ref('NATInstance')
  end
end
```

Now we need to link the private route table to the private subnet. Like we did
for the public subnet, we can use Convection's `ec2_subnet_route_table_association`
method.

Add the below to the bottom of your vpc.rb template.

```ruby
ec2_subnet_route_table_association 'PrivateRouteAssoc' do
  route_table fn_ref('PrivateRouteTable')
  subnet fn_ref('PrivateSubnet')
end

```

Diffing the template shows three new resources, one for the route, one for the
route table, and one for the subnet association.

```text
$> convection diff

compare  Compare local state of stack vpc (convection-demo-vpc) with remote template
 create  .Resources.PrivateRouteTableRoutePrivateRoute.Type: AWS::EC2::Route
 create  .Resources.PrivateRouteTableRoutePrivateRoute.Properties.RouteTableId.Ref: PrivateRouteTable
 create  .Resources.PrivateRouteTableRoutePrivateRoute.Properties.DestinationCidrBlock: 0.0.0.0/0
 create  .Resources.PrivateRouteTableRoutePrivateRoute.Properties.InstanceId.Ref: NATInstance
 create  .Resources.PrivateRouteTable.Type: AWS::EC2::RouteTable
 create  .Resources.PrivateRouteTable.Properties.VpcId.Ref: DemoVPC
 create  .Resources.PrivateRouteAssoc.Type: AWS::EC2::SubnetRouteTableAssociation
 create  .Resources.PrivateRouteAssoc.Properties.RouteTableId.Ref: PrivateRouteTable
 create  .Resources.PrivateRouteAssoc.Properties.SubnetId.Ref: PrivateSubnet
```

Converge the stack and create the new resources.

```text
$> convection converge

converge  Stack vpc
update_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack) User Initiated
create_in_progress  PrivateRouteTable: (AWS::EC2::RouteTable)
create_in_progress  PrivateRouteTable: (AWS::EC2::RouteTable) Resource creation Initiated
create_complete  PrivateRouteTable: (AWS::EC2::RouteTable)
create_in_progress  PrivateRouteTableRoutePrivateRoute: (AWS::EC2::Route)
create_in_progress  PrivateRouteAssoc: (AWS::EC2::SubnetRouteTableAssociation)
create_in_progress  PrivateRouteTableRoutePrivateRoute: (AWS::EC2::Route) Resource creation Initiated
create_in_progress  PrivateRouteAssoc: (AWS::EC2::SubnetRouteTableAssociation) Resource creation Initiated
create_complete  PrivateRouteAssoc: (AWS::EC2::SubnetRouteTableAssociation)
create_complete  PrivateRouteTableRoutePrivateRoute: (AWS::EC2::Route)
update_complete_cleanup_in_progress  convection-demo-vpc: (AWS::CloudFormation::Stack)
update_complete  convection-demo-vpc: (AWS::CloudFormation::Stack)
```

## Where to go from here ##

We used Convection to build an Amazon VPC with public and private subnets,
complete with a NAT router for handling internet traffic and a security group
for locking down access. From here we could add bastion servers to get SSH
access to EC2 instances in the private subnet, or network ACLs to further harden
the VPC.

Whatever we do, we now have a solid workflow for making infrastructure
improvements. Make a small change. Diff to see what's going to be updated.
Converge the change if it looks good.


[vpc2]: http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Scenario2.html
[cf-template]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html
[cf-vpc]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc.html
[cf-subnet]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html
[ec2-subnet]: https://github.com/rapid7/convection/blob/v0.2/lib/convection/model/template/resource/aws_ec2_subnet.rb
[cf-ref]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-ref.html
[cf-ec2]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-instance.html
[cf-security-group]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html
[cf-internet-gateway]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-internet-gateway.html
[cf-route-table]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route-table.html
[cf-gateway-attachment]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc-gateway-attachment.html
[cf-route]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route.html
[cf-association]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet-route-table-assoc.html
[nat-instance]: http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_NAT_Instance.html
