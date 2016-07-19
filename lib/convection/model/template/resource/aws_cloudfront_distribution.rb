require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::CloudFront::Distribution
        #
        # Creates an Amazon CloudFront web distribution.   See
        # {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution.html AWS::CloudFront::Distribution}.
        #
        # @example
        #
        # cloudfront_distribution 'MySiteWebsite' do
        #   config do
        #     cname 'mysite.example.com'
        #     default_root_object 'index.html'
        #     price_class 'PriceClass_100'
        #     default_cache_behavior do
        #       forwarded_values do
        #         query_string false
        #       end
        #       target_origin 's3-mysite-bucket'
        #       viewer_protocol_policy 'redirect-to-https'
        #     end
        #     origin do
        #       id 's3-mysite-bucket'
        #       domain_name "mysite.example.com.s3-website-#{stack.region}.amazonaws.com"
        #       custom_origin do
        #         protocol_policy 'http-only'
        #       end
        #     end
        #     viewer_certificate do
        #       iam_certificate 'EXAMPLECERTID'
        #       minimum_protocol_version 'TLSv1'
        #       ssl_support_method 'sni-only'
        #     end
        #   end
        # end
        #
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
