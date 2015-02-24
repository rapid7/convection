require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::SQS::QueuePolicy
        ##
        class SQSQueuePolicy < Resource
          property :policy_document, 'PolicyDocument'

          def initialize(*args)
            super

            type 'AWS::SQS::QueuePolicy'
            @properties['Queues'] = []
          end

          def queue(value)
            @properties['Queues'] << value
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
