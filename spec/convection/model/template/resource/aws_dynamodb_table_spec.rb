require 'spec_helper'

class Convection::Model::Template::Resource
  describe DynamoDBTable do
    let(:template) do
      Convection.template do
        dynamodb_table 'TestTable' do
          #A attribute definitions {'AttributeName' : String, 'AttributeType' : String}
          attribute_definitions  'AttributeName' => 'Name', 'AttributeType' => 'Type'
          #A key schema {'AttributeName' : String, 'KeyType' : 'HASH or RANGE'}
          key_schema 'AttributeName' => 'Name', 'KeyType' => 'HASH'
          #Provisioned throughout hash {'ReadCapacityUnits' : Number, 'WriteCapacityUnits' : Number}
          provisioned_throughput 'ReadCapacityUnits' => 100, 'WriteCapacityUnits' => 100
          #optional
          #A global seconday index { 'IndexName' : String, 'KeySchema' : [ KeySchema, ... ], 'Projection' : { Projection }, 'ProvisionedThroughput' : { ProvisionedThroughput }}
          global_secondary_indexes 'IndexName' => 'Name', 'KeySchema' => [{'AttributeName' => 'Name', 'KeyType' => 'HASH'}] , 'Projection' => {'NonKeyAttributes' =>[ {'AttributeName' => 'Name2', 'AttributeType' => 'Type'} ], 'ProjectionType'=>'Type'} , 'ProvisionedThroughput' =>{'ReadCapacityUnits' => 100, 'WriteCapacityUnits' => 100}
          #A local secondary index { 'IndexName' : String, 'KeySchema' : [ KeySchema, ...], 'Projection' : { Projection }}
          local_secondary_indexes 'IndexName' => 'Name', 'KeySchema' => [{'AttributeName' => 'Name', 'KeyType' => 'HASH'}] , 'Projection' => {'NonKeyAttributes' =>[ {'AttributeName' => 'Name2', 'AttributeType' => 'Type'} ], 'ProjectionType'=>'Type'}
          #A point in time recovery specification { 'PointInTimeRecoveryEnabled' : Boolean}
          point_in_time_recovery_specification 'PointInTimeRecoveryEnabled' => true
          #A sse specification { 'SSEEnabled' : Boolean}
          sse_specification 'SSEEnabled' => false
          #A stream specification { 'StreamViewType' : String}
          stream_specification 'StreamViewType' => 'Type'
          table_name 'TableName'
          #A time to live specification { 'AttributeName' : String, 'Enabled' : Boolean}
          time_to_live_specification 'AttributeName' => 'Name', 'Enabled' => true
          tag 'Name', 'Test'
        end
      end
    end

    subject do
      template_json
          .fetch('Resources')
          .fetch('TestTable')
          .fetch('Properties')
    end

    it 'sets the AttributeDefinitions' do
      expect(subject['AttributeDefinitions']).to include(hash_including('AttributeName' => 'Name', 'AttributeType' => 'Type'))
    end

    it 'sets the KeySchema' do
      expect(subject['KeySchema']).to include(hash_including('AttributeName' => 'Name', 'KeyType' => 'HASH'))
    end

    it 'sets the ProvisionedThroughput' do
      expect(subject['ProvisionedThroughput']).to include('ReadCapacityUnits' => 100, 'WriteCapacityUnits' => 100)
    end

    it 'sets the GlobalSecondaryIndexes' do
      expect(subject['GlobalSecondaryIndexes']).to include(hash_including('IndexName' => 'Name', 'KeySchema' => [ {'AttributeName' => 'Name', 'KeyType' => 'HASH'} ], 'Projection' => {'NonKeyAttributes' => [ {'AttributeName' => 'Name2', 'AttributeType' => 'Type'} ], 'ProjectionType' => 'Type'}, 'ProvisionedThroughput' => {'ReadCapacityUnits' => 100, 'WriteCapacityUnits' => 100}))
    end

    it 'sets the LocalSecondaryIndexes' do
      expect(subject['LocalSecondaryIndexes']).to include(hash_including('IndexName' => 'Name', 'KeySchema' => [ {'AttributeName' => 'Name', 'KeyType' => 'HASH'} ], 'Projection' => {'NonKeyAttributes' => [ {'AttributeName' => 'Name2', 'AttributeType' => 'Type'} ], 'ProjectionType' => 'Type'}))
    end

    it 'sets the PointInTimeRecoverySpecification' do
      expect(subject['PointInTimeRecoverySpecification']).to include('PointInTimeRecoveryEnabled' => true)
    end

    it 'sets the SSESpecification' do
      expect(subject['SSESpecification']).to include('SSEEnabled' => false)
    end

    it 'sets the StreamSpecification' do
      expect(subject['StreamSpecification']).to include('StreamViewType' => 'Type')
    end

    it 'sets the TableName' do
      expect(subject['TableName']).to eq('TableName')
    end

    it 'sets the TimeToLiveSpecification' do
      expect(subject['TimeToLiveSpecification']).to include('AttributeName' => 'Name', 'Enabled' => true)
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
