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

          def initialize(*args)
            super
            type 'AWS::RDS::DBInstance'
            @property['DBSecurityGroups'] = []
            @property['VPCSecurityGroups'] = []
          end

          def allocated_storage(value)
            property('AllocatedStorage', value)
          end

          def allow_major_version_upgrade(value)
            property('AllowMajorVersionUpgrade', value)
          end

          def auto_minor_version_upgrade(value)
            property('AutoMinorVersionUpgrade', value)
          end

          def availability_zone(value)
            property('AvailabilityZone', value)
          end

          def backup_retention_period(value)
            property('BackupRetentionPeriod', value)
          end

          def db_instance_class(value)
            property('DBInstanceClass', value)
          end

          def db_instance_identifier(value)
            property('DBInstanceIdentifier', value)
          end

          def db_name(value)
            property('DBName', value)
          end

          def db_parameter_group_name(value)
            property('DBParameterGroupName', value)
          end

          def db_security_groups(value)
            @property['DBSecurityGroups'] << value
          end

          def db_snapshot_identifier(value)
            property('DBSnapshotIdentifier', value)
          end

          def db_subnet_group_name(value)
            property('DBSubnetGroupName', value)
          end

          def engine(value)
            property('Engine', value)
          end

          def engine_version(value)
            property('EngineVersion', value)
          end

          def iops(value)
            property('Iops', value)
          end

          def license_model(value)
            property('LicenseModel', value)
          end

          def master_username(value)
            property('MasterUsername', value)
          end

          def master_user_password(value)
            property('MasterUserPassword', value)
          end

          def multi_az(value)
            property('MultiAZ', value)
          end

          def option_group_name(value)
            property('OptionGroupName', value)
          end

          def port(value)
            property('Port', value)
          end

          def preferred_backup_window(value)
            property('PreferredBackupWindow', value)
          end

          def preferred_maintenance_window(value)
            property('PreferredMaintenanceWindow', value)
          end

          def publicly_accessible(value)
            property('PubliclyAccessible', value)
          end

          def source_db_instance_identifier(value)
            property('SourceDBInstanceIdentifier', value)
          end

          def storage_type(value)
            property('StorageType', value)
          end

          def vpc_security_groups(value)
            @property['VPCSecurityGroups'] << value
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

  module DSL
    ## Add DSL method to template namespace
    module Template
      def db_instance(name, &block)
        r = Model::Template::Resource::RDSDBInstance.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end
    end
  end
end
