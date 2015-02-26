gem 'minitest'
require 'minitest/autorun'
require 'json'

class TestTemplate < Minitest::Test
  def setup
    @template = Convection.template do
      description 'Test Template'
    end
  end

  def from_json(json)
    JSON.parse(json)
  end

  def test_template_class
    assert_kind_of Convection::Model::Template, @template
  end

  def test_template_format_version
    json = JSON.parse(@template.to_json)
    json = json['AWSTemplateFormatVersion']
    assert_equal json, '2010-09-09'
  end

  def test_template_description
    json = JSON.parse(@template.to_json)
    json = json['Description']
    assert_equal json, 'Test Template'
  end

  %w(Parameters Mappings Conditions Resources).each do |section|
    define_method("test_template_#{section.downcase}") do
      json = JSON.parse(@template.to_json)
      json = json[section]
      assert_respond_to json, :has_key?, "#{section} expected to respond to :has_key? method"
    end
  end
end
