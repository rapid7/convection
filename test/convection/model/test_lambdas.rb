require 'test_helper'
require 'json'
require 'pp'

class TestLambdas < Minitest::Test
  def setup
    @template = ::Convection.template do
      description 'Conditions Test Template'

      lambda_function 'TestLambda' do
        description 'Test description'
        handler 'index.handler'
        runtime 'nodejs'
        role 'arn:aws:x:y:z'

        code do
          s3_bucket 'testbucket'
          s3_key 'testkey'
        end

        vpc_config do
          security_groups %w(group1 group2)
          subnets %w(subnet1a subnet1b)
        end
      end
    end
  end

  def from_json
    JSON.parse(@template.to_json)
  end

  def test_lambda
    json = from_json['Resources']['TestLambda']['Properties']

    code = json['Code']
    assert_equal 'testbucket', code['S3Bucket']
    assert_equal 'testkey', code['S3Key']

    assert_equal 'arn:aws:x:y:z', json['Role']

    vpc = json['VpcConfig']
    refute vpc.nil?, 'VpcConfig not present in generated template'

    secgroups = vpc['SecurityGroupIds']
    assert secgroups.is_a?(Array), 'SecurityGroupIds is not an array'
    assert_equal 2, secgroups.size

    subnets = vpc['SubnetIds']
    assert subnets.is_a?(Array), 'SubnetIds is not an array'
    assert_equal 2, subnets.size
  end
end
