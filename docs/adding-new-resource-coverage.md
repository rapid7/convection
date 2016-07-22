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
        class EC2DHCPOptions < Resource
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
        class EC2DHCPOptions < Resource
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
        class EC2DHCPOptions < Resource
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
6. The completed class should look like the below. Once you are finished developing the class add a yard doc example.
```ruby
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::DHCPOptions
        #
        # @example
        #   ec2_dhcp_options 'TestOptions' do
        #     domain_name 'example.com'
        #     domain_name_servers  '10.0.0.1', '10.0.0.2'
        #     netbios_name_servers '10.0.0.1', '10.0.0.2'
        #     netbios_node_type 1
        #     ntp_servers '10.0.0.1', '10.0.0.2'
        #     tag 'Name', 'Test'
        #   end
        ##
        class EC2DHCPOptions < Resource
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
7. Unit Tests! Adding tests for resources is simple, create a new test class. `convection/spec/convection/model/template/resource/ec2_dhcp_options_spec.rb`
8. Set up the basic structure of the class.
```ruby
require 'spec_helper'

class Convection::Model::Template::Resource
  describe DHCPOptions do
    let(:template) do
      Convection.template do


      end
    end

  end
end
```
9. Add the mock template. Below is a example
```ruby
require 'spec_helper'

class Convection::Model::Template::Resource
  describe DHCPOptions do
    let(:template) do
      Convection.template do

        ec2_dhcp_options 'TestOptions' do
          domain_name 'example.com'
          domain_name_servers  '10.0.0.1', '10.0.0.2'
          netbios_name_servers '10.0.0.1', '10.0.0.2'
          netbios_node_type 1
          ntp_servers '10.0.0.1', '10.0.0.2'
        end
      end
    end

  end
end
```
10. Lets add some helper methods to get retrieve our template parameters. See below, NOTE we added the `subject` block and `template_json` method.
```ruby
require 'spec_helper'

class Convection::Model::Template::Resource
  describe EC2DHCPOptions do
    let(:template) do
      Convection.template do

        ec2_dhcp_options 'TestOptions' do
          domain_name 'example.com'
          domain_name_servers  '10.0.0.1', '10.0.0.2'
          netbios_name_servers '10.0.0.1', '10.0.0.2'
          netbios_node_type 1
          ntp_servers '10.0.0.1', '10.0.0.2'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('TestOptions')
        .fetch('Properties')
    end


    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
```
11. Test time, below is our complete spec file with test for the defined parameters. Note in the test where we reference values in the subject object `subject['DomainName']` the hash key we use is the one set in our property block `property :domain_name, 'DomainName'`.
```ruby
require 'spec_helper'

class Convection::Model::Template::Resource
  describe EC2DHCPOptions do
    let(:template) do
      Convection.template do

        ec2_dhcp_options 'TestOptions' do
          domain_name 'example.com'
          domain_name_servers  '10.0.0.1', '10.0.0.2'
          netbios_name_servers '10.0.0.1', '10.0.0.2'
          netbios_node_type 1
          ntp_servers '10.0.0.1', '10.0.0.2'
          tag 'Name', 'Test'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('TestOptions')
        .fetch('Properties')
    end

    it 'sets the DomainName' do
      expect(subject['DomainName']).to eq('example.com')
    end

    it 'sets the DomainNameServers' do
      expect(subject['DomainNameServers']).to match_array(['10.0.0.1', '10.0.0.2'])
    end

    it 'sets the NetbiosNameServers' do
      expect(subject['NetbiosNameServers']).to match_array(['10.0.0.1', '10.0.0.2'])
    end

    it 'sets the NetbiosNodeType' do
      expect(subject['NetbiosNodeType']).to eq(1)
    end

    it 'sets the NtpServers' do
      expect(subject['NtpServers']).to match_array(['10.0.0.1', '10.0.0.2'])
    end

    it 'sets tags' do
      expect(subject['Tags']).to include(hash_including('Key' => 'Name', 'Value' => 'Test'))
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end

```