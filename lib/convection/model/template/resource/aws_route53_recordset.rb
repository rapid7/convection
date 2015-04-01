require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Instance
        ##
        class Route53RecordSet < Resource
          property :alias_target, 'AliasTarget'
          property :comment, 'Comment'
          property :failover, 'Failover'
          property :geo_location, 'GeoLocation', :array
          property :health_check_id, 'HealthCheckId'
          property :zone, 'HostedZoneId'
          property :zone_name, 'HostedZoneName'
          property :record_name, 'Name'
          property :region, 'Region'
          property :record, 'ResourceRecords', :array
          property :set_identifier, 'SetIdentifier'
          property :ttl, 'TTL'
          property :record_type, 'Type'
          property :weight, 'Weight'

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
