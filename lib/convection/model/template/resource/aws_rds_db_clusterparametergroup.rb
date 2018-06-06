require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::RDS::DBClusterParameterGroup
        #  rds_cluster_parameter_group 'DemoRDSClusterParameterGroup' do
        #    description 'Sample Aurora Cluster Parameter Group'
        #    family 'aurora5.6'
        #    parameter 'time_zone', 'US/Eastern'
        #    tag 'Name', 'Test'
        #  end
        ##
        class RDSDBClusterParameterGroup < Resource
          include Model::Mixin::Taggable

          type 'AWS::RDS::DBClusterParameterGroup', :rds_cluster_parameter_group
          property :description, 'Description'
          property :family, 'Family'
          property :parameter, 'Parameters', :type => :hash

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
