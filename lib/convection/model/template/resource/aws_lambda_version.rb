require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Lambda::Version
        ##
        class LambdaVersion < Resource
          type 'AWS::Lambda::Version'
          property :code_sha256, 'CodeSha256'
          property :description, 'Description'
          property :function_name, 'FunctionName'
        end
      end
    end
  end
end
