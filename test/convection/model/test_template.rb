require 'test_helper'
require 'json'
require 'pp'

class TestTemplate < Minitest::Test
  def setup
    @template = Convection.template do
      description 'Test Template'

      ec2_instance 'TestInstance1' do
        availability_zone 'us-east-1'
        image_id 'ami-asdf83'
      end

      ec2_instance 'TestInstance2' do
        availability_zone 'us-west-1'
        image_id 'ami-lda34f'
        depends_on 'TestInstance1'
      end
    end
  end

  def from_json
    JSON.parse(@template.to_json)
  end

  def test_template_class
    assert_kind_of Convection::Model::Template, @template
  end

  def test_template_format_version
    assert_equal '2010-09-09', from_json['AWSTemplateFormatVersion']
  end

  def test_template_description
    assert_equal 'Test Template', from_json['Description']
  end

  %w(Parameters Mappings Conditions Resources).each do |section|
    define_method("test_template_#{section.downcase}") do
      assert_respond_to from_json[section], :key?, "#{section} expected to respond to :key? method"
    end
  end

  def test_template_resources
    assert_includes from_json['Resources'], 'TestInstance1'
  end

  def instance1
    from_json['Resources']['TestInstance1']
  end

  def test_template_instance_has_properties
    assert_includes instance1, 'Properties'
  end

  def test_template_instance_type
    assert_equal 'AWS::EC2::Instance', instance1['Type']
  end

  def test_template_depends_on
    assert_includes from_json['Resources']['TestInstance2']['DependsOn'], 'TestInstance1'
  end
end
