require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Instance
        ##
        class Route53RecordSet < Resource
          TF_ASSUMED_RESOURCE_NAME = 'aws_elastic_load_balancing_load_balancer'.freeze
          TF_ACTUAL_RESOURCE_NAME = 'aws_elb'.freeze

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

          def alias_target(tgt = nil, &block)
            if tgt
              # Maintain backwards compatability
              alias_tgt tgt
            else
              # Add new resource_property functionality
              a = ResourceProperty::Route53AliasTarget.new(self)
              a.instance_exec(&block) if block
              properties['AliasTarget'].set(a)
            end
          end

          def geo_location(geo = nil, &block)
            if geo
              # Maintain backwards compatability
              geo_loc geo
            else
              # Add new resource_property functionality
              g = ResourceProperty::Route53GeoLocation.new(self)
              g.instance_exec(&block) if block
              properties['GeoLocation'].set(g)
            end
          end

          def terraform_import_commands(module_path: 'root')
            commands = []
            commands << '# Import the Route53 record:'
            tf_set_id = "_#{set_identifier}" if set_identifier
            prefix = "#{module_path}." unless module_path == 'root'
            tf_record_name = record_name.sub(/\.$/, '')
            commands << "terraform import #{prefix}aws_route53_record.#{name.underscore} #{hosted_zone_id}_#{tf_record_name}_#{record_type}#{tf_set_id}"

            commands.map { |cmd| cmd.gsub(stack.region, stack._original_region).gsub(stack.cloud, stack._original_cloud) }
          end

          def to_hcl_json(*)
            tf_record_attrs = {
              zone_id: hosted_zone_id,
              name: record_name,
              type: record_type,
              ttl: ttl,
              records: tf_records,
              set_identifier: set_identifier
            }
            tf_record_attrs.reject! { |_k, v| v.nil? }

            tf_record = {
              aws_route53_record: {
                name.underscore => tf_record_attrs
              }
            }

            { resource: [tf_record] }.to_json
          end

          private

          def tf_records
            record.map { |r| r.gsub(TF_ASSUMED_RESOURCE_NAME, TF_ACTUAL_RESOURCE_NAME) }
          end
        end
      end
    end
  end
end
