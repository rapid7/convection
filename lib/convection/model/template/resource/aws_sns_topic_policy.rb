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
          # @example
          # sns_topic_policy 'TopicPolicy' do
          #   topic "my-sns-topic"
          #   allow do
          #     principal :Service => 's3.amazonaws.com'
          #     sns_resource my_region, my_account, "my-sns-topic"
          #     action 'sns:Publish'
          #     condition :ArnLike => { "AWS:SourceArn" => "arn:aws:s3:......." }
          #   end
          # end
          extend Forwardable

          type 'AWS::SNS::TopicPolicy'
          property :topic, 'Topics', :type => :list
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
