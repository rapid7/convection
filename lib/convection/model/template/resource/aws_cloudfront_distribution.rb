require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::CloudFront::Distribution
        ##
        class CloudFrontDistribution < Resource
          include Model::Mixin::Taggable

          type 'AWS::CloudFront::Distribution', :cloudfront_distribution
          property :config, 'DistributionConfig'

          # Append a network interface to network_interfaces
          def config(&block)
            config = ResourceProperty::CloudFrontDistributionConfig.new(self)
            config.instance_exec(&block) if block
            properties['DistributionConfig'].set(config)
          end

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
