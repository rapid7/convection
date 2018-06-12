require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::RDS::DBCluster
        #
        # @example
        #      rds_cluster 'TestCluster' do
        #           availability_zone 'us-east-1','us-east-2'
        #           backup_retention 10
        #           database_name 'test_database'
        #           identifier 'cluster1'
        #           cluster_parameter_group_name 'default.aurora5.6'
        #           subnet_group 'subnet_group'
        #           engine 'aurora'
        #           engine_version '5.6.10a'
        #           kms_key_id 'kms_key'
        #           master_username 'username'
        #           master_password 'password'
        #           port '3306'
        #           preferred_backup_window '12:30-01:30'
        #           preferred_maintenance_window 'mon:2:30-mon:3:30'
        #           replication_source_identifier 'source_instance'
        #           snapshot_identifier
        #           storage_encrypted 'false'
        #           tag 'Name', 'Test'
        #           vpc_security_group 'test_security_group_1' ,'test_security_group_2'
        #       end
        ##
        class RDSDBCluster < Resource
          include Model::Mixin::Taggable

          type 'AWS::RDS::DBCluster', :rds_cluster

          property :availability_zone, 'AvailabilityZones', :type => :list
          property :backup_retention, 'BackupRetentionPeriod'
          property :database_name, 'DatabaseName'
          property :identifier, 'DBClusterIdentifier'
          property :cluster_parameter_group_name, 'DBClusterParameterGroupName'
          property :subnet_group, 'DBSubnetGroupName'
          property :engine, 'Engine'
          property :engine_version, 'EngineVersion'
          property :kms_key_id, 'KmsKeyId'
          # only specify username and password  if you do not specify SnapshotIdentifier
          property :master_username, 'MasterUsername'
          property :master_password, 'MasterUserPassword'
          property :port, 'Port'
          # backup window must be in the format hh24:mi-hh24:mi, atleast 30 mins long, UTC, cannot conflict with maintenance window.
          property :preferred_backup_window, 'PreferredBackupWindow'
          # backup window must be in the format ddd:hh24:mi-ddd:hh24:mi, atleast 30 mins long, UTC, cannot conflict with backup window.
          property :preferred_maintenance_window, 'PreferredMaintenanceWindow'
          property :replication_source_identifier, 'ReplicationSourceIdentifier'
          property :snapshot_identifier, 'SnapshotIdentifier'
          property :storage_encrypted, 'StorageEncrypted'

          property :vpc_security_group, 'VpcSecurityGroupIds', :type => :list

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
