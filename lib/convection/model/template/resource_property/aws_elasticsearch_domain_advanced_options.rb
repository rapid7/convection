require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticsearch-domain.html#cfn-elasticsearch-domain-advancedoptions
        # Advanced Options Property Type}
        class ElasticsearchDomainAdvancedOptions < ResourceProperty
          property :indices_query_bool_max_clause_count, 'indices.query.bool.max_clause_count'
          property :rest_action_multi_allow_explicit_index, 'rest.action.multi.allow_explicit_index'
        end
      end
    end
  end
end
