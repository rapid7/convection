require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::SQS::QueuePolicy
        ##
        class SQSQueuePolicy < Resource
          property :policy, 'PolicyDocument'

          def initialize(*args)
            super

            type 'AWS::SQS::QueuePolicy'
            @queues = []
          end

          def render(*args)
            super.tap do |resource|
              resource['Properties']['Queues'] = queues.map(&:render)
              render_tags(resource)
            end
          end

        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def sqs_queue_policy(name, &block)
        r = Model::Template::Resource::SQSQueuePolicy.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
