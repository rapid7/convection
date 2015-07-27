require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Logs::LogGroup
        ##
        class LogGroup < Resource

          property :retention_in_days, 'RetentionInDays'
      
          def initialize(*args)
            super
            type 'AWS::Logs::LogGroup'
          end

        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def logs_log_group(name, &block)
        r = Model::Template::Resource::LogGroup.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
