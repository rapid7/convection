require_relative '../resource'

module Convection
  module DSL
    ## Add DSL method to template namespace
    module Template
      def iam_instance_profile(name, &block)
        r = Model::Template::Resource::IAMInstanceProfile.new(name, self)
        r.instance_exec(&block) if block

        resources[name] = r
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::IstanceProfile
        ##
        class IAMInstanceProfile < Resource
          property :path, 'Path'

          ## List of references to AWS::IAM::Roles.
          ## Currently, a maximum of one role can be assigned to an instance profile.
          property :role, 'Roles', :array

          def initialize(*args)
            super
            type 'AWS::IAM::InstanceProfile'
          end
        end
      end
    end
  end
end
