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

          property :availability_zone, 'AvailabilityZone'
          property :image_id, 'ImageId'
          property :instance_type, 'InstanceType'
          property :instance_profile, 'IamInstanceProfile'
          property :key_name, 'KeyName'
          property :subnet, 'SubnetId'
          property :user_data, 'UserData'

          def initialize(*args)
            super

            type 'AWS::EC2::Instance'
            @properties['SecurityGroupIds'] = []
          end

          ## Accumulate SecurityGroups
          def security_group(value)
            @properties['SecurityGroupIds'] << value
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
        r = Model::Template::Resource::EC2Instance.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
