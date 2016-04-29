require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::DirectoryService::SimpleAD
        ##
        class DirectoryServiceSimpleAD < Resource
          type 'AWS::DirectoryService::SimpleAD', :directoryservice_simple_ad
          property :description, 'Description'
          property :enable_sso, 'EnableSso'
          property :name, 'Name'
          property :password, 'Password'
          property :short_name, 'ShortName'
          property :size, 'Size'
          property :vpc_settings, 'VpcSettings', :type => :hash
        end
      end
    end
  end
end
