require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Instance
        ##
        class Route53RecordSet < Resource
          type 'AWS::Route53::RecordSet', :route53_recordset
          property :alias_tgt, 'AliasTarget'
          property :comment, 'Comment'
          property :failover, 'Failover'
          property :geo_loc, 'GeoLocation'
          property :health_check_id, 'HealthCheckId'
          property :hosted_zone_id, 'HostedZoneId'
          alias zone hosted_zone_id # for backward compatability
          property :hosted_zone_name, 'HostedZoneName'
          alias zone_name hosted_zone_name # for backward compatability
          property :record_name, 'Name'
          property :region, 'Region'
          property :record, 'ResourceRecords', :array
          property :set_identifier, 'SetIdentifier'
          property :ttl, 'TTL'
          property :record_type, 'Type'
          property :weight, 'Weight'

          # Add new resource_property functionality
          def alias_target(&block)
            a = ResourceProperty::Route53AliasTarget.new(self)
            a.instance_exec(&block) if block
            properties['AliasTarget'].set(a)
          end

          # Maintain backwards compatability
          def alias_target(obj)
            alias_tgt obj
          end

          # Add new resource_property functionality
          def geo_location(&block)
            g = ResourceProperty::Route53GeoLocation.new(self)
            g.instance_exec(&block) if block
            properties['GeoLocation'].set(g)
          end

          # Maintain backwards compatability
          def geo_location(obj)
            geo_loc obj
          end
        end
      end
    end
  end
end
