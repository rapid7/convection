require 'test_helper'
require 'json'
require 'pp'

class TestTrust < Minitest::Test
  def setup
    @template = ::Convection.template do
      description 'Trust Test Template'

      iam_role 'FooRole' do
        trust_service 'bar'
      end
    end
  end

  def from_json
    JSON.parse(@template.to_json)
  end

  def test_trust
    json = from_json['Resources']['FooRole']['Properties']
    doc = json['AssumeRolePolicyDocument']
    refute doc.nil?, 'No policy document present in JSON'
    stmt = doc['Statement']

    trust_bar = stmt.any? { |s| s['Principal']['Service'] == 'bar.amazonaws.com' }
    assert_equal true, trust_bar, 'Expected to find [bar.amazonaws.com] in document'
  end
end
