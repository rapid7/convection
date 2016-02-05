module Convection
  module Model
    module Mixin
      ##
      # Add definition helpers for entities with policies
      ##
      class Policy
        include DSL::Helpers

        DEFAULT_VERSION = '2012-10-17'.freeze

        attribute :name
        attribute :id
        attribute :version
        list :statement

        def initialize(options = {})
          @name = options.fetch(:name) { SecureRandom.uuid }
          @version = DEFAULT_VERSION
          @statement = []

          @template = options[:template]
        end

        def allow(sid = nil, &block)
          add_statement = Statement.new('Allow', @template)
          add_statement.sid = sid unless sid.nil?
          add_statement.instance_exec(&block) if block

          statement(add_statement)
        end

        def document
          {
            'Version' => version,
            'Statement' => statement.map(&:render)
          }
        end

        def render(parent = {})
          parent.tap do |resource|
            resource['PolicyName'] = name unless name.is_a?(FalseClass)
            resource['PolicyDocument'] = document
          end
        end

        ##
        # An IAM policy statement
        ##
        class Statement
          include DSL::Helpers

          attribute :sid
          attribute :effect
          attribute :principal
          attribute :condition
          list :action
          list :resource

          def s3_resource(bucket, path = nil)
            return resource "arn:aws:s3:::#{ bucket }/#{ path }" unless path.nil?
            resource "arn:aws:s3:::#{ bucket }"
          end

          def initialize(effect = 'Allow', template = nil)
            @effect = effect

            @action = []
            @resource = []

            @template = template
          end

          def render
            {
              'Effect' => effect,
              'Action' => action,
              'Resource' => resource
            }.tap do |statemant|
              statemant['Sid'] = sid unless sid.nil?
              statemant['Condition'] = condition unless condition.nil?
              statemant['Principal'] = principal unless principal.nil?
            end
          end
        end
      end
    end
  end
end
