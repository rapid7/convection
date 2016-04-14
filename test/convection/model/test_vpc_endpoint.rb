require 'test_helper'
require 'json'
require 'pp'

class TestVpcEndpoint < Minitest::Test
  def setup
    @template = ::Convection.template do
      description 'VPC Endpoint Test Template'

      ec2_vpc_endpoint 'TestVpcEndpoint' do
        service 's3'
        vpc 'vpc-foo'
        route_tables %w(table1 table2)

        allow do
          s3_resource 'bucket-bar', '*'
          action 's3:GetObject'
        end
      end
    end
  end

  def from_json
    JSON.parse(@template.to_json)
  end

  def test_endpoint
    json = from_json['Resources']

    pp json
    endpoint = json['TestVpcEndpoint']
    refute endpoint.nil?, 'VpcEndpoint not present in generated template'

    props = endpoint['Properties']
    assert_equal 'vpc-foo', props['VpcId']

    service_name = props['ServiceName']
    refute service_name.nil?, 'ServiceName not present in generated template'

    assert service_name.is_a? Hash
    s3_string_arr = service_name['Fn::Join']
    refute s3_string_arr.nil?, 'ServiceName value is not specified as a string array'

    assert s3_string_arr.is_a? Array
    assert s3_string_arr[1][2] == 's3', 'ServiceName does not contain \'s3\' as final element'
  end
end