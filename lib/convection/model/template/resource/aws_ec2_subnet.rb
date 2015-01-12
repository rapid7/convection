require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Subnet
        ##
        class EC2Subnet < Resource
          include Model::Mixin::CIDRBlock
          include Model::Mixin::Taggable

          def initialize(*args)
            super
            type 'AWS::EC2::Subnet'
          end

          def availability_zone(value)
            property('AvailabilityZone', value)
          end

          def vpc_id(value)
            property('VpcId', value)
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

  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_subnet(name, &block)
        r = Model::Template::Resource::EC2Subnet.new(name, self)
        r.instance_exec(&block) if block

        resources[name] = r
      end
    end
  end
end
