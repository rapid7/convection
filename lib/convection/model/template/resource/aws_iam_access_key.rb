require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::IAM::AccessKey
        ##
        class IAMAccessKey < Resource
          property :serial, 'Serial'
          property :status, 'Status'
          property :user_name, 'UserName'

          def initialize(*args)
            super
            type 'AWS::IAM::AccessKey'

            @properties['Serial'] = 0
            @properties['Status'] = 'Active'
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def iam_access_key(name, &block)
        r = Model::Template::Resource::IAMAccessKey.new(name, self)
        r.instance_exec(&block) if block

        resources[name] = r
      end
    end
  end

end
