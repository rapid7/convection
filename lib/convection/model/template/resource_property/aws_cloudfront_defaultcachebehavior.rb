require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents a {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-defaultcachebehavior.html
        # CloudFront DefaultCacheBehavior Embedded Property Type}
        class CloudFrontDefaultCacheBehavior < ResourceProperty
          property :allowed_methods, 'AllowedMethods', :type => :list, :default => %w(HEAD GET)
          property :cached_methods, 'CachedMethods', :type => :list
          property :compress, 'Compress'
          property :default_ttl, 'DefaultTTL'
          property :forwarded_values, 'ForwardedValues'
          property :max_ttl, 'MaxTTL'
          property :min_ttl, 'MinTTL'
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
