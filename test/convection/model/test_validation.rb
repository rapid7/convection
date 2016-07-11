require 'test_helper'
require 'json'
require 'pp'

class TestValidations < Minitest::Test
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
    @excessive_mapping_name = ::Convection.template do
      description 'Validations Test Template - Excessive Mapping Name'
      mapping '0' * 256 do
        item '1', '2', '3'
      end
    end

    assert_raises(ExcessiveMappingsError) do
      @excessive_mappings.to_json
    end
    assert_raises(ExcessiveMappingNameError) do
      @excessive_mapping_name.to_json
    end
  end

  def test_mapping_attributes
    @excessive_mapping_attributes = ::Convection.template do
      description 'Validations Test Template - Too Many Mapping Attributes'
      mapping 'Mapping_Example' do
        31.times do |count|
          item "#{count}_1", "#{count}_2", "#{count}_3"
        end
      end
    end
    @excessive_mapping_attribute_names = ::Convection.template do
      description 'Validations Test Template - Excessive Mapping Attribute Name'
      mapping 'Mapping_1' do
        item '0' * 256, 'value', 'value'
      end
    end

    assert_raises(ExcessiveMappingAttributesError) do
      @excessive_mapping_attributes.to_json
    end
    assert_raises(ExcessiveMappingAttributeNameError) do
      @excessive_mapping_attribute_names.to_json
    end
  end
end
