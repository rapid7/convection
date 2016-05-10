require_relative '../resource'

module Convection
  module DSL
    module Template
      module Resource
        ##
        # DSL For VPC sub-entities
        ##
        module EC2VPC
          ## Expose other resource DSL handles inside of the VPC closure
          include DSL::Template::Resource

          def add_internet_gateway(&block)
            g = Model::Template::Resource::EC2InternetGateway.new("#{ name }IG", @template)
            g.attach_to_vpc(self)
            g.tag('Name', "#{ name }InternetGateway")

            g.instance_exec(&block) if block
            @template.resources[g.name] = g

            ## Store the gateway for later reference
            @internet_gateway = g
          end

          def add_network_acl(name, &block)
            network_acl = Model::Template::Resource::EC2NetworkACL.new("#{ self.name }ACL#{ name }", @template)
            network_acl.vpc(self)
            network_acl.tag('Name', network_acl.name)

            network_acl.instance_exec(&block) if block
            @template.resources[network_acl.name] = network_acl
          end

          def add_route_table(name, options = {}, &block)
            route_table = Model::Template::Resource::EC2RouteTable.new("#{ self.name }Table#{ name }", @template)
            route_table.vpc(self)
            route_table.tag('Name', route_table.name)

            route_table.instance_exec(&block) if block

            @template.resources[route_table.name] = route_table
            return route_table unless options[:gateway_route]

            ## Create and associate an InterntGateway
            add_internet_gateway if @internet_gateway.nil?

            ## Create a route to the VPC's InternetGateway
            vpc_default_route = route_table.route('Default')
            vpc_default_route.destination('0.0.0.0/0')
            vpc_default_route.gateway(@internet_gateway)

            route_table
          end

          def add_subnet(name, &block)
            s = Model::Template::Resource::EC2Subnet.new("#{ self.name }Subnet#{ name }", @template)
            s.tag('Name', s.name)
            s.vpc(self)

            ## Allocate the next available subnet
            @subnet_allocated += 1
            subnets = network.subnet(:Bits => @subnet_length,
                                      :NumSubnets => @subnet_allocated)
            s.network(subnets[@subnet_allocated - 1])

            s.instance_exec(&block) if block
            @template.resources[s.name] = s
          end
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::VPC
        ##
        class EC2VPC < Resource
          include DSL::Template::Resource::EC2VPC
          include Mixin::Taggable
          extend Mixin::CIDRBlock

          type 'AWS::EC2::VPC'
          attribute :subnet_length
          property :instance_tenancy, 'InstanceTenancy'
          cidr_property :network, 'CidrBlock'

          def initialize(*args)
            super

            @subnet_allocated = 0
            @subnet_length = 24

            @internet_gateway = nil
          end

          def enable_dns(value = true)
            property('EnableDnsSupport', value)
            property('EnableDnsHostnames', value)
          end

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
