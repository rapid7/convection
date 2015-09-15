require 'forwardable'
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::SNS::TopicPolicy
        ##
        class SNSTopicPolicy < Resource
          extend Forwardable

          type 'AWS::SNS::TopicPolicy'
          property :topics, 'Topics'
          attr_reader :document #, 'PolicyDocument'

          def_delegators :@document, :allow, :id, :version, :statement
          def_delegator :@document, :name, :policy_name

          def initialize(*args)
            super
            @document = Model::Mixin::Policy.new(:name => false, :template => @template)
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
