require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::IstanceProfile
        ##
        class IAMInstanceProfile < Resource
          type 'AWS::IAM::InstanceProfile'
          property :path, 'Path'

          ## List of references to AWS::IAM::Roles.
          ## Currently, a maximum of one role can be assigned to an instance profile.
          property :role, 'Roles', :type => :list
        end
      end
    end
  end
end
