require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::EIP
        ##
        class EC2EIP < Resource
          type 'AWS::EC2::EIP'
          property :instance, 'InstanceId'
          property :domain, 'Domain'
        end
      end
    end
  end
end
