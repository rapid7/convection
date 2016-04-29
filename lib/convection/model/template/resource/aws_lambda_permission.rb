require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Lambda::Permission
        ##
        class LambdaPermission < Resource
          type 'AWS::Lambda::Permission'
          property :action, 'Action'
          property :function_name, 'FunctionName'
          property :principal, 'Principal'
          property :source_account, 'SourceAccount'
          property :source_arn, 'SourceArn'
        end
      end
    end
  end
end
