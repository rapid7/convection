require 'spec_helper'

class Convection::Model::Template::Resource
  describe RDSDBCluster do
    let(:template) do
      Convection.template do
        rds_cluster 'TestCluster' do
          availability_zone 'us-east-1', 'us-east-2'
          backup_retention 10
          database_name 'test_database'
          identifier 'cluster1'
          cluster_parameter_group_name 'default.aurora5.6'
          subnet_group 'subnet_group'
          engine 'aurora'
          engine_version '5.6.10a'
          kms_key_id 'kms_key'
          master_username 'username'
          master_password 'password'
          port '3306'
          preferred_backup_window '12:30-01:30'
          preferred_maintenance_window 'mon:2:30-mon:3:30'
          replication_source_identifier 'source_instance'
          snapshot_identifier
          storage_encrypted 'false'
          tag 'Name', 'Test'
          vpc_security_group 'test-security-group-1', 'test-security-group-2'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('TestCluster')
        .fetch('Properties')
    end

    it 'sets the DBClusterIdentifier' do
      expect(subject['DBClusterIdentifier']).to eq('cluster1')
    end

    it 'sets the Engine' do
      expect(subject['Engine']).to eq('aurora')
    end

    it 'sets the EngineVersion' do
      expect(subject['EngineVersion']).to eq('5.6.10a')
    end

    it 'sets the StorageEncrypted' do
      expect(subject['StorageEncrypted']).to eq('false')
    end

    it 'sets the Port' do
      expect(subject['Port']).to eq('3306')
    end

    it 'sets the BackupRetentionPeriod' do
      expect(subject['BackupRetentionPeriod']).to eq(10)
    end

    it 'sets the DatabaseName' do
      expect(subject['DatabaseName']).to eq('test_database')
    end

    it 'sets the MasterUsername' do
      expect(subject['MasterUsername']).to eq('username')
    end

    it 'sets the MasterUserPassword' do
      expect(subject['MasterUserPassword']).to eq('password')
    end

    it 'sets the KmsKeyId' do
      expect(subject['KmsKeyId']).to eq('kms_key')
    end

    it 'sets the PreferredBackupWindow' do
      expect(subject['PreferredBackupWindow']).to eq('12:30-01:30')
    end

    it 'sets the PreferredMaintenanceWindow' do
      expect(subject['PreferredMaintenanceWindow']).to eq('mon:2:30-mon:3:30')
    end

    it 'sets the AvailabilityZones' do
      expect(subject['AvailabilityZones']).to match_array(['us-east-1', 'us-east-2'])
    end

    it 'sets the DBSubnetGroupName' do
      expect(subject['DBSubnetGroupName']).to eq('subnet_group')
    end

    it 'sets the DBSubnetGroupName' do
      expect(subject['DBSubnetGroupName']).to eq('subnet_group')
    end

    it 'sets the VPCSecurityGroupIds' do
      expect(subject['VPCSecurityGroupIds']).to match_array(['test-security-group-1', 'test-security-group-2'])
    end

    it 'sets the ReplicationSourceIdentifier' do
      expect(subject['ReplicationSourceIdentifier']).to eq('source_instance')
    end

    it 'sets the DBClusterParameterGroupName' do
      expect(subject['DBClusterParameterGroupName']).to eq('default.aurora5.6')
    end

    it 'sets tags' do
      expect(subject['Tags']).to include(hash_including('Key' => 'Name', 'Value' => 'Test'))
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
