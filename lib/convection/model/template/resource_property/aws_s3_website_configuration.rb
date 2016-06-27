require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-website.html
        # Amazon S3 Website Configuration}
        class S3WebsiteConfiguration < ResourceProperty
          property :error_document, 'ErrorDocument'
          property :index_document, 'IndexDocument'
          property :redirect_all_requests_to, 'RedirectAllRequestsTo'
          property :routing_rules, 'RoutingRules', :type => :list

          def redirect_all_requests_to(&block)
            redirect_destination = ResourceProperty::S3WebsiteConfigurationRedirectAllRequestsTo.new(self)
            redirect_destination.instance_exec(&block) if block
            properties['RedirectAllRequestsTo'].set(redirect_destination)
          end

          def routing_rule(&block)
            routing_rule = ResourceProperty::S3WebsiteConfigurationRoutingRule.new(self)
            routing_rule.instance_exec(&block) if block
            routing_rules << routing_rule
          end
        end
      end
    end
  end
end
