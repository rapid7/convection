require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Elasticsearch::Domain
        ##
        class ElasticsearchDomain < Resource
          include Model::Mixin::Taggable

          type 'AWS::Elasticsearch::Domain', :elasticsearch_domain
          property :domain_name, 'DomainName'
          property :elasticsearch_version, 'ElasticsearchVersion'
          property :elasticsearch_cluster_config, 'ElasticsearchClusterConfig'
          property :access_policies, 'AccessPolicies'
          property :vpc_options, 'VPCOptions'
          property :ebs_options, 'EBSOptions'
          property :snapshot_options, 'SnapshotOptions'
          property :advanced_options, 'AdvancedOptions'

          def elasticsearch_cluster_config(&block)
            elasticsearch_cluster_config = ResourceProperty::ElasticsearchDomainElasticsearchClusterConfig.new(self)
            elasticsearch_cluster_config.instance_exec(&block) if block
            properties['ElasticsearchClusterConfig'].set(elasticsearch_cluster_config)
          end

          def vpc_options(&block)
            vpc_options = ResourceProperty::ElasticsearchDomainVPCOptions.new(self)
            vpc_options.instance_exec(&block) if block
            properties['VPCOptions'].set(vpc_options)
          end

          def ebs_options(&block)
            ebs_options = ResourceProperty::ElasticsearchDomainEBSOptions.new(self)
            ebs_options.instance_exec(&block) if block
            properties['EBSOptions'].set(ebs_options)
          end

          def snapshot_options(&block)
            snapshot_options = ResourceProperty::ElasticsearchDomainSnapshotOptions.new(self)
            snapshot_options.instance_exec(&block) if block
            properties['SnapshotOptions'].set(snapshot_options)
          end

          def advanced_options(&block)
            advanced_options = ResourceProperty::ElasticsearchDomainAdvancedOptions.new(self)
            advanced_options.instance_exec(&block) if block
            properties['AdvancedOptions'].set(advanced_options)
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
