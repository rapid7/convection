require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::SubnetRouteTableAssociation
        ##
        class EC2SubnetNetworkACLAssociation < Resource
          property :acl, 'NetworkAclId'
          property :subnet, 'SubnetId'

          def initialize(*args)
            super
            type 'AWS::EC2::SubnetNetworkAclAssociation'
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_subnet_network_acl_association(name, &block)
        assoc = Model::Template::Resource::EC2SubnetNetworkACLAssociation.new(name, self)

        assoc.instance_exec(&block) if block
        resources[name] = assoc
      end
    end
  end
end
