require 'forwardable'
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::Policy
        ##
        class IAMPolicy < Resource
          extend Forwardable

          type 'AWS::IAM::Policy'
          attr_reader :document
          def_delegators :@document, :allow, :id, :version, :statement
          def_delegator :@document, :name, :policy_name

          def initialize(*args)
            super
            @document = Model::Mixin::Policy.new(:template => @template)

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
