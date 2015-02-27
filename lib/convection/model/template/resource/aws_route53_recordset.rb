require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Instance
        ##
        class Route53RecordSet < Resource
          property :comment, 'Comment'
          property :zone, 'HostedZoneId'
          property :record_name, 'Name'
          property :record, 'ResourceRecords', :array
          property :ttl, 'TTL'
          property :record_type, 'Type'

          def initialize(*args)
            super
            type 'AWS::Route53::RecordSet'
          end
        end
      end
    end
  end

  module DSL
    ## Add DSL method to template namespace
    module Template
      def route53_recordset(name, &block)
        r = Model::Template::Resource::Route53RecordSet.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
