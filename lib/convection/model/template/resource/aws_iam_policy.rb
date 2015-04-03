require 'forwardable'
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

      module Resource
        ## IAMPolicy DSL
        module IAMPolicy
          def allow(&block)

          end
        end
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
          extend Forwardable
          include DSL::Template::Resource::IAMPolicy

          attr_reader :document
          attr_reader :groups
          attr_reader :roles
          attr_reader :users

          def_delegators :@document, :allow, :id, :version, :statement
          def_delegator :@document, :name, :policy_name

          def initialize(*args)
            super

            type 'AWS::IAM::Policy'
            @document = Model::Mixin::Policy.new('shared-policy', @template)

            @properties['Groups'] = []
            @properties['Roles'] = []
            @properties['Users'] = []
          end

          def group(resource)
            depends_on(resource)
            @properties['Groups'] << (resource.is_a?(Resource) ? resource.reference : resource)
          end

          def role(resource)
            depends_on(resource)
            @properties['Roles'] << (resource.is_a?(Resource) ? resource.reference : resource)
          end

          def user(resource)
            depends_on(resource)
            @properties['Users'] << (resource.is_a?(Resource) ? resource.reference : resource)
          end

          def render
            document.render(@properties)
            super
          end
        end
      end
    end
  end
end
