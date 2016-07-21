#Adding a CloudFormation resource to Convection
This guide will document how convection support for AWS::EC2::DHCPOptions was added. This example can be followed to add coverage for other CloudFormation resources

1. Create a new class `convection/lib/convection/model/template/resource/aws_ec2_dhcp_options.rb` See the example below.

```ruby
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::DHCPOptions
        ##
        class DHCPOptions < Resource
          type 'AWS::EC2::DHCPOptions'
        end
      end
    end
  end
end
```

2. Go to the CloudFormation resource documentation and use that as a guide for how you will define the resource properties. Viewing the [DHCPOptions] (http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-dhcp-options.html) api doc we can see that we have several resource properties we will need to handle.

```json
{
   "Type" : "AWS::EC2::DHCPOptions",
   "Properties" : {
      "DomainName" : String,
      "DomainNameServers" : [ String, ... ],
      "NetbiosNameServers" : [ String, ... ],
      "NetbiosNodeType" : Number,
      "NtpServers" : [ String, ... ],
      "Tags" : [ Resource Tag, ... ]
   }
}
```

3. Lets define the properties. Map the json key value pairs to ruby. `"DomainName" : String` in json will be defined in our template as `property :domain_name, 'DomainName'`. So with our first property added our new convection resource class will look like

```ruby
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::DHCPOptions
        ##
        class DHCPOptions < Resource
          type 'AWS::EC2::DHCPOptions'
          property :domain_name, 'DomainName'
        end
      end
    end
  end
end
```

4. You have probably noticed that some of these parameters expect a string array. For those we will add `:type => :list`. See below

```ruby
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::DHCPOptions
        ##
        class DHCPOptions < Resource
          type 'AWS::EC2::DHCPOptions'
          property :domain_name, 'DomainName'
          property :domain_name_servers, 'DomainNameServers', :type => :list
          property :netbios_name_servers, 'NetbiosNameServers', :type => :list
          property :netbios_node_type, 'NetbiosNodeType'
          property :ntp_servers, 'NtpServers', :type => :list
        end
      end
    end
  end
end
```

5. To add tag support to the resource add the below block and include

```ruby
include Model::Mixin::Taggable

def render(*args)
  super.tap do |resource|
    render_tags(resource)
  end
end
```

6. The completed class should look like the below

```ruby
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::DHCPOptions
        ##
        class DHCPOptions < Resource
          include Model::Mixin::Taggable

          type 'AWS::EC2::DHCPOptions'
          property :domain_name, 'DomainName'
          property :domain_name_servers, 'DomainNameServers', :type => :list
          property :netbios_name_servers, 'NetbiosNameServers', :type => :list
          property :netbios_node_type, 'NetbiosNodeType'
          property :ntp_servers, 'NtpServers', :type => :list

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
```