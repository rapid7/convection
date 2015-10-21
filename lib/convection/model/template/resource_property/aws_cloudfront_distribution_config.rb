require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distributionconfig.html
        # CloudFront DistributionConfig Embedded Property Type}
        class CloudFrontDistributionConfig < ResourceProperty
          # NOTE: we avoid overloading Ruby's alias here by using cname
          property :cname, 'Aliases', :type => :list
          property :cache_behaviors, 'CacheBehaviors', :type => :list
          property :comment, 'Comment'
          property :custom_error_responses, 'CustomErrorResponses', :type => :array
          property :default_cache_behavior, 'DefaultCacheBehavior'
          property :default_root_object, 'DefaultRootObject'
          property :enabled, 'Enabled', :default => true
          property :logging, 'Logging'
          property :origins, 'Origins', :type => :list
          property :price_class, 'PriceClass'
          property :restrictions, 'Restrictions'
          property :viewer_certificate, 'ViewerCertificate'

          def cache_behavior(&block)
            behavior = ResourceProperty::CloudFrontCacheBehavior.new(self)
            behavior.instance_exec(&block) if block
            cache_behaviors << behavior
          end

          def custom_error_response(&block)
            response = ResourceProperty::CloudFrontCustomErrorResponse.new(self)
            response.instance_exec(&block) if block
            custom_error_responses << response
          end

          def default_cache_behavior(&block)
            behavior = ResourceProperty::CloudFrontDefaultCacheBehavior.new(self)
            behavior.instance_exec(&block) if block
            properties['DefaultCacheBehavior'].set(behavior)
          end

          def logging(&block)
            logging = ResourceProperty::CloudFrontLogging.new(self)
            logging.instance_exec(&block) if block
            properties['Logging'].set(logging)
          end


          def origin(&block)
            origin = ResourceProperty::CloudFrontOrigin.new(self)
            origin.instance_exec(&block) if block
            origins << origin
          end

          def restrictions(&block)
            restrictions = ResourceProperty::CloudFrontRestrictions.new(self)
            restrictions.instance_exec(&block) if block
            properties['Restrictions'].set(restrictions)
          end

          def viewer_certificate(&block)
            cert = ResourceProperty::CloudFrontViewerCertificate.new(self)
            cert.instance_exec(&block) if block
            properties['ViewerCertificate'].set(cert)
          end
        end
      end
    end
  end
end
