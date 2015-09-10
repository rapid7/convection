require 'test_helper'
require 'json'
require 'pp'

class TestValidations < Minitest::Test

  def test_within_limits
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
        mapping "Mapping_#{count}" do
          item 'one', 'two', 'three'
          item '1', '2', '3'
        end
        output "Output_#{count}" do
          description 'An Important Attribute'
          value get_att('Resource', 'Attribute')
        end
        parameter "Parameter_#{count}" do
          type 'String'
          description 'Example Parameter'
          default 'm3.medium'
        end
      end
    end

    assert_nothing_raised(StandardError) do
      @within_limits.to_json
    end
  end

  def test_bytesize
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
      80.times do |count|
        mapping "Mapping_#{count}" do
          item 'us-east-1', 'test', 'cf-test-keys'
          item 'us-west-1', 'test', 'cf-test-keys'
        end
      end
    end
    assert_raises(ExcessiveTemplateSizeError) do
      JSON.generate(@excessive_bytesize.to_json).bytesize
    end
  end

  def test_resources
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

    assert_raises(ExcessiveResourcesError) do
      @excessive_resources.to_json
    end
    assert_raises(ExcessiveResourceNameError) do
      @excessive_resource_name.to_json
    end
  end

  def test_mappings
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
        item "1", "2", "3"
      end
    end
    @excessive_mapping_attribute_names = ::Convection.template do
      description 'Validations Test Template - Excessive Mapping Attribute Name'
      mapping "Mapping_1" do
        item "0" *256, "value", "value"
      end
    end

    assert_raises(ExcessiveMappingsError) do
      @excessive_mappings.to_json
    end
    assert_raises(ExcessiveMappingNameError) do
      @excessive_mapping_name.to_json
    end
    assert_raises(ExcessiveMappingAttributesError)do
      @excessive_mapping_attributes.to_json
    end
    assert_raises(ExcessiveMappingAttributeNameError) do
      @excessive_mapping_attribute_names.to_json
    end
  end

  def test_outputs
    @excessive_outputs = ::Convection.template do
      description 'Validations Test Template - Too Many Outputs'
      61.times do |count|
        output "Output_#{count}" do
          description 'An Important Attribute'
          value get_att('Resource', 'Attribute')
        end
      end
    end

    @excessive_output_name = ::Convection.template do
      description 'Validations Test Template - Excessive Output Name'
      output "0" * 256 do
        description 'An Important Attribute'
        value get_att('Resource', 'Attribute')
      end
    end

    assert_raises(ExcessiveOutputsError) do
      @excessive_outputs.to_json
    end
    assert_raises(ExcessiveOutputNameError) do
      @excessive_output_name.to_json
    end
  end

  def test_parameters
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

    assert_raises(ExcessiveParametersError) do
      @excessive_parameters.to_json
    end
    assert_raises(ExcessiveParameterNameError) do
      @excessive_parameter_name.to_json
    end
    assert_raises(ExcessiveParameterBytesizeError) do
      @excessive_parameter_value_bytesize.to_json
    end
  end

  def test_description
    @excessive_description = ::Convection.template do
      description "0" * 1_025
    end

    assert_raises(ExcessiveDescriptionError) do
      @excessive_description.to_json
    end
  end
end
