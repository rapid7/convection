require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::AccessKey
        ##
        class IAMAccessKey < Resource
          type 'AWS::IAM::AccessKey'
          property :serial, 'Serial', :default => 0
          property :status, 'Status', :default => 'Active'
          property :user_name, 'UserName'
        end
      end
    end
  end
end
