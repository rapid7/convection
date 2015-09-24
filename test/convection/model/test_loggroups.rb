require 'test_helper'
require 'json'
require 'pp'

class TestLogGroups < Minitest::Test
  def setup
    @template = ::Convection.template do
      description 'Logroups Test Template'

      resource 'testgroup' do
        type 'AWS::Logs::LogGroup'
        property 'RetentionInDays', 365
      end
    end
  end

  def from_json
    JSON.parse(@template.to_json)
  end

  def test_log_groups
    refute_empty(from_json['Resources'])
    assert_includes(from_json['Resources'], 'testgroup')
  end
end
