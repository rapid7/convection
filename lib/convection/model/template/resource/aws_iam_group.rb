require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::Group
        ##
        class IAMGroup < Resource
          property :path, 'Path'

          def initialize(*args)
            super

            type 'AWS::IAM::Group'
            @properties['Policies'] = []
          end

          def policy(value)
            @properties['Policies'] << value
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def iam_group(name, &block)
        r = Model::Template::Resource::IAMGroup.new(name, self)
        r.instance_exec(&block) if block

        resources[name] = r
      end
    end
  end

end
