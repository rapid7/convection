require 'forwardable'
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::SQS::QueuePolicy
        ##
        class SQSQueuePolicy < Resource
          extend Forwardable

          type 'AWS::SQS::QueuePolicy'
          property :queue, 'Queues', :type => :list
          attr_reader :document

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
