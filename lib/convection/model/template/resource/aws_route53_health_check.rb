require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Route53::HealthCheck
        ##
        class Route53HealthCheck < Resource
          type 'AWS::Route53::HealthCheck', :route53_healthcheck
          property :health_check_config, 'HealthCheckConfig'
        end
      end
    end
  end
end
