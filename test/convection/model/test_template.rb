require 'test_helper'
require 'json'
require 'pp'

class TestTemplate < Minitest::Test
  def setup
    @template = Convection.template do
      description 'Test Template'

      instance1 = ec2_instance 'TestInstance1' do
        availability_zone 'us-east-1'
        image_id 'ami-asdf83'
      end

      instance2 = ec2_instance 'TestInstance2' do
        availability_zone 'us-west-1'
        image_id 'ami-lda34f'
        depends_on instance1.name
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
    json = from_json['AWSTemplateFormatVersion']
    assert_equal '2010-09-09', json
  end

  def test_template_description
    json = from_json['Description']
    assert_equal 'Test Template', json
  end

  %w(Parameters Mappings Conditions Resources).each do |section|
    define_method("test_template_#{section.downcase}") do
      json = from_json[section]
      assert_respond_to json, :has_key?, "#{section} expected to respond to :has_key? method"
    end
  end

  def test_template_resources
    assert_includes from_json['Resources'], 'TestInstance1'
  end

  def instance1
    json = from_json['Resources']
    json = json['TestInstance1']
  end

  def test_template_instance_has_properties
    assert_includes instance1, 'Properties'
  end

  def test_template_instance_type
    json = instance1['Type']
    assert_equal 'AWS::EC2::Instance', json
  end

  def test_template_depends_on
    json = from_json['Resources']
    json = json['TestInstance2']['DependsOn']
    assert_includes json, 'TestInstance1'
  end
end
