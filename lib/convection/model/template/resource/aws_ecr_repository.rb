require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ECR::Repository
        ##
        class ECRRepository < Resource
          type 'AWS::ECR::Repository'
          property :repository_name, 'RepositoryName'
          property :repository_policy_text, 'RepositoryPolicyText'
        end
      end
    end
  end
end
