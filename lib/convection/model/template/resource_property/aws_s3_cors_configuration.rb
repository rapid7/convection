require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-cors.html
        # Amazon S3 Cors Configuration}
        class S3CorsConfiguration < ResourceProperty
          property :cors_rules, 'CorsRules', :type => :list

          def cors_rule(&block)
            cors_rule = ResourceProperty::S3CorsConfigurationRule.new(self)
            cors_rule.instance_exec(&block) if block
            cors_rules << cors_rule
          end
        end
      end
    end
  end
end
