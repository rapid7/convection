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
        end
      end
    end
  end
end
