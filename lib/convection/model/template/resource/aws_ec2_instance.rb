require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Instance
        ##
        class EC2Instance < Resource
          include Model::Mixin::Taggable

          def initialize(*args)
            super

            type 'AWS::EC2::Instance'
            @properties['SecurityGroupIds'] = []
          end

          def availability_zone(value)
            property('AvailabilityZone', value)
          end

          def image_id(value)
            property('ImageId', value)
          end

          def instance_type(value)
            property('InstanceType', value)
          end

          def key_name(value)
            property('KeyName', value)
          end

          def security_group(value)
            @properties['SecurityGroupIds'] << value
          end

          def subnet(value)
            property('SubnetId', value)
          end

          def user_data(value)
            property('UserData', value)
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
      def ec2_instance(name, &block)
        r = Model::Template::Resource::EC2Instance.new
        r.instance_exec(&block) if block

        resources[name] = r
      end
    end
  end
end
