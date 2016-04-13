require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::ManagedPolicy
        ##
        class IAMManagedPolicy < Resource
          extend Forwardable

          type 'AWS::IAM::ManagedPolicy'
          property :path, 'Path'
          property :description, 'Description'
          property :group, 'Groups', :type => :list
          property :role, 'Roles', :type => :list
          property :user, 'Users', :type => :list

          attr_reader :document
          def_delegators :@document, :allow, :deny, :id, :version, :statement

          def initialize(*args)
            super
            @document = Model::Mixin::Policy.new(:template => @template)
          end

          def render
            super.tap do |r|
              document.render(r['Properties'])
              r['Properties'].delete('PolicyName')
            end
          end
        end
      end
    end
  end
end
