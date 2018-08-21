require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::DynamoDB::Table
        #
        # @example
        #      dynamodb_table 'TestTable' do
        #           #A attribute definitions { 'AttributeName' : String, 'AttributeType' : String }
        #           attribute_definitions  'AttributeName' => 'Name', 'AttributeType' => 'Type'
        #           #A key schema { 'AttributeName' : String, 'KeyType' : 'HASH or RANGE' }
        #           key_schema 'AttributeName' => 'Name', 'KeyType' => 'HASH'
        #           #Provisioned throughout hash { 'ReadCapacityUnits' : Number, 'WriteCapacityUnits' : Number }
        #           provisioned_throughput 'ReadCapacityUnits' => 100, 'WriteCapacityUnits' => 100
        #           #optional
        #           #A global seconday index { 'IndexName' : String, 'KeySchema' : [KeySchema, ... ],
        #           'Projection' : { Projection }, 'ProvisionedThroughput' : { ProvisionedThroughput }}
        #           global_secondary_indexes 'IndexName' => 'Name', 'KeySchema' => [{' AttributeName' => 'Name', 'KeyType' => 'HASH' }],
        #           'Projection' => { 'NonKeyAttributes' => [{ 'AttributeName' => 'Name2', 'AttributeType' => 'Type' }], 'ProjectionType'=>'Type' },
        #           'ProvisionedThroughput' =>{ 'ReadCapacityUnits' => 100, 'WriteCapacityUnits' => 100 }
        #           #A local secondary index { 'IndexName' : String, 'KeySchema' : [ KeySchema, ...], 'Projection' : { Projection }}
        #           local_secondary_indexes 'IndexName' => 'Name', 'KeySchema' => [{ 'AttributeName' => 'Name', 'KeyType' => 'HASH' }],
        #           'Projection' => {'NonKeyAttributes' =>[ {'AttributeName' => 'Name2', 'AttributeType' => 'Type'} ], 'ProjectionType'=>'Type' }
        #           #A point in time recovery specification { 'PointInTimeRecoveryEnabled' : Boolean}
        #           point_in_time_recovery_specification 'PointInTimeRecoveryEnabled' => true
        #           #A sse specification { 'SSEEnabled' : Boolean }
        #           sse_specification 'SSEEnabled' => false
        #           #A stream specification { 'StreamViewType' : String }
        #           stream_specification 'StreamViewType' => 'Type'
        #           table_name 'TableName'
        #           #A time to live specification { 'AttributeName' : String, 'Enabled' : Boolean }
        #           time_to_live_specification 'AttributeName' => 'Name', 'Enabled' => true
        #           tag 'Name', 'Test'
        #      end
        ##
        class DynamoDBTable < Resource
          include Model::Mixin::Taggable

          type 'AWS::DynamoDB::Table', :dynamodb_table

          # required
          # A attribute definitions {"AttributeName" : String, "AttributeType" : String}
          # type can be s for string, n for numeric, or b for binary data
          property :attribute_definitions, 'AttributeDefinitions', :type => :list #list of attribute definitions
          # A key schema {"AttributeName" : String, "KeyType" : "HASH or RANGE"}
          property :key_schema, 'KeySchema', :type => :list #list of key schema
          # Provisioned throughout hash {"ReadCapacityUnits" : Number, "WriteCapacityUnits" : Number}
          property :provisioned_throughput, 'ProvisionedThroughput'
          # optional
          # A global seconday index { "IndexName" : String, "KeySchema" : [KeySchema, ... ],
          # "Projection" : { Projection }, "ProvisionedThroughput" : { ProvisionedThroughput }}
          property :global_secondary_indexes, 'GlobalSecondaryIndexes', :type => :list #list of global secondary indexes
          # A local secondary index { "IndexName" : String, "KeySchema" : [ KeySchema, ...], "Projection" : { Projection }}
          property :local_secondary_indexes, 'LocalSecondaryIndexes', :type => :list
          # A point in time recovery specification { "PointInTimeRecoveryEnabled" : Boolean}
          property :point_in_time_recovery_specification, 'PointInTimeRecoverySpecification'
          # A sse specification { "SSEEnabled" : Boolean}
          property :sse_specification, 'SSESpecification'
          # A stream specification { "StreamViewType" : String}
          property :stream_specification, 'StreamSpecification'
          property :table_name, 'TableName'
          # A time to live specification { "AttributeName" : String, "Enabled" : Boolean}
          property :time_to_live_specification, 'TimeToLiveSpecification'

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