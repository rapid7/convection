require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Lambda::Alias
        ##
        class LambdaAlias < Resource
          type 'AWS::Lambda::Alias'
          property :description, 'Description'
          property :function_name, 'FunctionName'
          property :function_version, 'FunctionVersion'
          property :alias_name, 'Name'
        end
      end
    end
  end
end
