require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::Group
        ##
        class IAMGroup < Resource
          type 'AWS::IAM::Group'
          property :path, 'Path'
          property :policy, 'Policies', :array
        end
      end
    end
  end
end
