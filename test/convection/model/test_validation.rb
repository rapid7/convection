require 'test_helper'
require 'json'
require 'pp'

class TestValidations < Minitest::Test

  def setup
    @within_limits = ::Convection.template do
      description 'Validations Test Template - Within Limits'
      10.times do |count|
        resource "EC2_INSTANCE_#{count}" do
          type 'AWS::EC2::Instance'
          property 'AvailabilityZone', 'us-east-1a'
          property 'ImageId', 'ami-76e27e1e'
          property 'KeyName', 'test'
          property 'SecurityGroupIds', ['sg-dd733c41', 'sg-dd738df3']
          property 'Tags', [{
            'Key' => 'Name',
            'Value' => 'test-1'
            }]
          end
        end
      10.times do |count|
        mapping "Mapping_#{count}" do
          item 'one', 'two', 'three'
          item '1', '2', '3'
        end
      end
      10.times do |count|
        output "Output_#{count}" do
          description 'An Important Attribute'
          value get_att('Resource', 'Attribute')
        end
      end
      10.times do |count|
        parameter "Parameter_#{count}" do
          type 'String'
          description 'Example Parameter'
          default 'm3.medium'
        end
      end
    end
    @excessive_bytesize = ::Convection.template do
      description 'Validations Test Template - Excessive Bytesize'
      200.times do |count|
        resource "EC2_INSTANCE_#{count}" do
          type 'AWS::EC2::Instance'
          property 'AvailabilityZone', 'us-east-1a'
          property 'ImageId', 'ami-76e27e1e'
          property 'KeyName', 'test'
          property 'SecurityGroupIds', ['sg-dd733c41', 'sg-dd738df3']
          property 'Tags', [{
            'Key' => 'Name',
            'Value' => 'test-1'
            }]
          end
        end
      100.times do |count|
        mapping "Mapping_#{count}" do
          item 'us-east-1', 'test', 'cf-test-keys'
          item 'us-west-1', 'test', 'cf-test-keys'
        end
      end
    end
    @excessive_description = ::Convection.template do
      description "0" * 1025
    end
    @excessive_resources = ::Convection.template do
      description 'Validations Test Template - Too Many Resources'
      201.times do |count|
        logs_log_group "Log_Group_#{count}" do
          retention_in_days 365
        end
      end
    end
    @excessive_resource_name = ::Convection.template do
      description 'Validations Test Template - Excessive Resource Name'
        logs_log_group "0"*256  do
          retention_in_days 365
        end
      end
    @excessive_mappings = ::Convection.template do
      description 'Validations Test Template - Too Many Mappings'
      101.times do |count|
        mapping "Mapping_#{count}" do
          item 'us-east-1', 'test', 'cf-test-keys'
          item 'us-west-1', 'test', 'cf-test-keys'
        end
      end
    end
    @excessive_mapping_attributes = ::Convection.template do
      description 'Validations Test Template - Too Many Mapping Attributes'
      mapping "Mapping_Example" do
        31.times do |count|
          item "#{count}_1", "#{count}_2", "#{count}_3"
        end
      end
    end
    @excessive_mapping_name = ::Convection.template do
      description 'Validations Test Template - Excessive Mapping Name'
      mapping "0" *256 do
        item "1","2","3"
      end
    end
    @excessive_mapping_attribute_names = ::Convection.template do
      description 'Validations Test Template - Excessive Mapping Attribute Name'
      mapping "Mapping_1" do
        item "0" *256,"value","value"
      end
    end
    @excessive_outputs = ::Convection.template do
      description 'Validations Test Template - Too Many Outputs'
      61.times do |count|
        output "Output_#{count}" do
          description 'An Important Attribute'
          value get_att('Resource', 'Attribute')
        end
      end
    end
    @excessive_parameters = ::Convection.template do
      description 'Validations Test Template - Too Many Parameters'
      61.times do |count|
        parameter "Parameter_#{count}" do
          type 'String'
          description 'Example Parameter'
          default 'm3.medium'
        end
      end
    end

    @excessive_parameter_name = ::Convection.template do
      description 'Validations Test Template - Excessive Parameter Name'
      parameter "0" * 256 do
        type 'String'
        description 'Example Parameter'
        default 'm3.medium'
      end
    end
    @excessive_parameter_value_bytesize  = ::Convection.template do
      description 'Validations Test Template - Excessive Parameter Value Bytesize'
      parameter "Excessive_Parameter" do
        type 'String'*150
        description 'Example Parameter'*150
        default 'm3.medium'*150
      end
    end
    @excessive_output_name = ::Convection.template do
      description 'Validations Test Template - Excessive Output Name'
      output "0" * 256 do
        description 'An Important Attribute'
        value get_att('Resource', 'Attribute')
      end
    end
  end

  def test_within_limits
    assert_nothing_raised(ArgumentError) {@within_limits.to_json}
  end
  def test_bytesize
    assert_raises(ArgumentError, "Error: Excessive Template Size") {JSON.generate(@excessive_bytesize.to_json).bytesize}
  end
  def test_resources
    assert_raises(ArgumentError, "Error: Excessive Number of Resources") {@excessive_resources.to_json}
    assert_raises(ArgumentError, "Error: Resource Name") {@excessive_resource_name.to_json}
  end
  def test_mappings
    assert_raises(ArgumentError, "Error: Excessive Number of Mappings") {@excessive_mappings.to_json}
    assert_raises(ArgumentError, "Error: Excessive Mapping Name") {@excessive_mapping_name.to_json}
    assert_raises(ArgumentError, "Error: Excessive Number of Mapping Attributes") {@excessive_mapping_attributes.to_json}
    assert_raises(ArgumentError, "Error: Excessive Mapping Attribute Name") {@excessive_mapping_attribute_names.to_json}
  end
  def test_outputs
    assert_raises(ArgumentError, "Error: Excessive Number of Outputs") {@excessive_outputs.to_json}
    assert_raises(ArgumentError, "Error: Output Name") {@excessive_output_name.to_json}
  end
  def test_parameters
    assert_raises(ArgumentError, "Error: Excessive Number of Parameters") {@excessive_parameters.to_json}
    assert_raises(ArgumentError, "Error: Parameter Name") {@excessive_parameter_name.to_json}
    assert_raises(ArgumentError, "Error: Excessive Parameter Size") {@excessive_parameter_value_bytesize.to_json}
  end
  def test_description
    assert_raises(ArgumentError, "Error: Excessive Description Size") {@excessive_description.to_json}
  end
end
