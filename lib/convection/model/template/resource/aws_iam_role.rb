require_relative '../resource'

module Convection
  module DSL
    ## Add DSL method to template namespace
    module Template
      def iam_role(name, &block)
        r = Model::Template::Resource::IAMRole.new(name, self)
        r.instance_exec(&block) if block

        resources[name] = r
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::Role
        ##
        class IAMRole < Resource
          def initialize(*args)
            super

            type 'AWS::IAM::Role'
            @properties['Policies'] = []
          end

          def path(value)
            property('Path', value)
          end

          def policies(value)
            @properties['Policies'] << value
          end

          def assume_role_policy_document(value)
            property('AssumeRolePolicyDocument', value)
          end
        end
      end
    end
  end
end
