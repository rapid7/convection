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
          property :group, 'Groups', :type => :list,
                                     :transform => (proc do |resource|
                                       depends_on(resource)
                                       resource
                                     end)
          property :role, 'Roles', :type => :list,
                                   :transform => (proc do |resource|
                                     depends_on(resource)
                                     resource
                                   end)
          property :user, 'Users', :type => :list,
                                   :transform => (proc do |resource|
                                     depends_on(resource)
                                     resource
                                   end)

          attr_reader :document
          def_delegators :@document, :allow, :id, :version, :statement
          def_delegator :@document, :name, :policy_name

          def initialize(*args)
            super
            @document = Model::Mixin::Policy.new(:template => @template)
          end

          def render
            super.tap do |r|
              document.render(r['Properties'])
            end
          end
        end
      end
    end
  end
end
