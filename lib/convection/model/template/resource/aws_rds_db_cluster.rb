require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::RDS::DBCluster
        ##
        class RDSDBCluster < Resource
          include Model::Mixin::Taggable

          type 'AWS::RDS::DBCluster', :rds_cluster

          property :identifier, 'DBClusterIdentifier'
          property :engine, 'Engine'
          property :engine_version, 'EngineVersion'
          property :storage_encrypted, 'StorageEncrypted'
          property :port, 'Port'
          property :backup_retention, 'BackupRetentionPeriod'
          property :database_name, 'DatabaseName'

          #only specify username and password  if you do not specify SnapshotIdentifier
          property :master_username, 'MasterUsername'
          property :master_password, 'MasterUserPassword'

          property :kms_key_id, 'KmsKeyId'
          property :snapshot_identifier, 'SnapshotIdentifier'

          #backup window must be in the format hh24:mi-hh24:mi, atleast 30 mins long, UTC, cannot conflict with maintenance window.
          property :preferred_backup_window, 'PreferredBackupWindow'
          #backup window must be in the format ddd:hh24:mi-ddd:hh24:mi, atleast 30 mins long, UTC, cannot conflict with backup window.
          property :preferred_maintenance_window, 'PreferredMaintenanceWindow'

          property :availability_zone, 'AvailabilityZones', :type => :list
          property :subnet_group, 'DBSubnetGroupName'
          property :vpc_security_group, 'VPCSecurityGroupIds', :type => :list

          property :replication_source_identifier, 'ReplicationSourceIdentifier'
          property :cluster_parameter_group_name, 'DBClusterParameterGroupName'

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