require_relative '../resource'

module Convection
  module DSL
    ## Add DSL method to template namespace
    module Template
      def iam_policy(name, &block)
        r = Model::Template::Resource::IAMPolicy.new(name, self)
        r.instance_exec(&block) if block

        resources[name] = r
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::Policy
        ##
        class IAMPolicy < Resource
          property :policy_name, 'PolicyName'
          property :policy, 'PolicyDocument'

          def initialize(*args)
            super

            type 'AWS::IAM::Policy'
            @properties['Groups'] = []
            @properties['Roles'] = []
            @properties['Users'] = []
          end

          def group(value)
            @properties['Groups'] << value
          end

          def role(value)
            @properties['Roles'] << value
          end

          def user(value)
            @properties['Users'] << value
          end
        end
      end
    end
  end
end
