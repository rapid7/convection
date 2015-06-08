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
          property :policy, 'Policies', :type => :list
        end
      end
    end
  end
end
