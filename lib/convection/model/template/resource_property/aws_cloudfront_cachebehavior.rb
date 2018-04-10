require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-cachebehavior.html
        # CloudFront DistributionConfig CacheBehavior Embedded Property Type}
        class CloudFrontCacheBehavior < ResourceProperty
          property :allowed_methods, 'AllowedMethods', :type => :list, :default => %w(HEAD GET)
          property :cached_methods, 'CachedMethods', :type => :list
          property :compress, 'Compress'
          property :forwarded_values, 'ForwardedValues'
          property :min_ttl, 'MinTTL'
          property :path_pattern, 'PathPattern', :default => '*'
          property :smooth_streaming, 'SmoothStreaming'
          property :target_origin, 'TargetOriginId'
          property :trusted_signer, 'TrustedSigners', :type => :list
          property :viewer_protocol_policy, 'ViewerProtocolPolicy', :default => 'allow-all'

          def forwarded_values(&block)
            values = ResourceProperty::CloudFrontForwardedValues.new(self)
            values.instance_exec(&block) if block
            properties['ForwardedValues'].set(values)
          end
        end
      end
    end
  end
end
