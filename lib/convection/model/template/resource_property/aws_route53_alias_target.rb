require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html
        # Route53 AliasTarget Property Type}
        class Route53AliasTarget < ResourceProperty
          property :dns_name, 'DNSName'
          property :evaluate_target_health, 'EvaluateTargetHealth'
          property :hosted_zone_id, 'HostedZoneId'
        end
      end
    end
  end
end
