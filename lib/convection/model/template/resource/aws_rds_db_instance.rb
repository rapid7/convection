require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::RDS::DBInstance
        ##
        class RDSDBInstance < Resource
          include Model::Mixin::Taggable

          type 'AWS::RDS::DBInstance', :rds_instance
          property :identifier, 'DBInstanceIdentifier'
          property :source_identifier, 'SourceDBInstanceIdentifier'
          property :instance_class, 'DBInstanceClass'
          property :engine, 'Engine'
          property :engine_version, 'EngineVersion'
          property :license_model, 'LicenseModel'
          property :storage_type, 'StorageType'
          property :iops, 'Iops'
          property :port, 'Port'
          property :master, 'SourceDBInstanceIdentifier'
          property :db_cluster_identifier, 'DBClusterIdentifier'

          property :database_name, 'DBName'
          property :master_username, 'MasterUsername'
          property :master_password, 'MasterUserPassword'

          property :parameter_group, 'DBParameterGroupName'
          property :option_group, 'OptionGroupName'

          property :storage_encrypted, 'StorageEncrypted'
          property :kms_key_id, 'KmsKeyId'
          property :allocated_storage, 'AllocatedStorage'
          property :allow_major_version_upgrade, 'AllowMajorVersionUpgrade'
          property :auto_minor_version_upgrade, 'AutoMinorVersionUpgrade'
          property :snapshot_identifier, 'DBSnapshotIdentifier'
          property :backup_retention_period, 'BackupRetentionPeriod'
          property :preferred_backup_window, 'PreferredBackupWindow'
          property :preferred_maintenance_window, 'PreferredMaintenanceWindow'
          property :deletion_protection, 'DeletionProtection'

          property :availability_zone, 'AvailabilityZone'
          property :multi_az, 'MultiAZ'
          property :publicly_accessible, 'PubliclyAccessible'
          property :subnet_group, 'DBSubnetGroupName'
          property :security_group, 'DBSecurityGroups', :type => :list
          property :vpc_security_group, 'VPCSecurityGroups', :type => :list

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
