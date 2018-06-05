require 'spec_helper'

class Convection::Model::Template::Resource
  describe RDSDBCluster do
    let(:template) do
      Convection.template do

        rds_db_cluster 'TestCluster' do

          identifier 'cluster1'
          engine 'aurora'
          engine_version '5.6.10a'
          storage_encrypted 'false'
          port '3306'
          backup_retention '10'
          database_name 'test_database'
          master_username 'username'
          master_password 'password'
          kms_key_id 'kms_key'
          snapshot_identifier
          preferred_backup_window '12:30-01:30'
          preferred_maintenance_window 'mon:2:30-mon:3:30'
          availability_zone 'us-east-1','us-east-2'
          subnet_group 'subnet_group'
          vpc_security_group 'test_security_group'
          replication_source_identifier 'source_instance'
          cluster_parameter_group_name 'default.aurora5.6'
          tag 'Name', 'Test'

        end


      end
    end
  end
end