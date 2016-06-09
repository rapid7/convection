require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Route53::HostedZone
        ##
        class Route53HostedZone < Resource
          include Model::Mixin::Taggable

          type 'AWS::Route53::HostedZone', :route53_hosted_zone
          property :config, 'HostedZoneConfig'
          property :name, 'Name'
          property :vpcs, 'VPCs', :type => :list

          def render(*args)
            super.tap do |resource|
              resource.tap do |r|
                r['Properties']['HostedZoneTags'] = tags.render unless tags.empty?
              end
            end
          end
        end
      end
    end
  end
end
