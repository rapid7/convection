require 'test_helper'
require 'json'

class TestLambdaPermission < Minitest::Test
  def setup
    @template = ::Convection.template do
      description 'Lambda Permission Test Template'

      lambda_permission 'LambdaInvokePermission' do
        action 'lambda:InvokeFunction'
        function_name get_att('MyLambdaFunction', 'Arn')
        principal 's3.amazonaws.com'
        source_account fn_ref('AWS::AccountId')
      end
    end
  end

  def from_json
    JSON.parse(@template.to_json)
  end

  def test_lambda_permission
    # Expected JSON:
    json = from_json['Resources']['LambdaInvokePermission']
    properties = json['Properties']

    assert_equal properties['Action'], 'lambda:InvokeFunction'
    assert_equal properties['FunctionName'], 'Fn::GetAtt' => ['MyLambdaFunction', 'Arn']
    assert_equal properties['SourceAccount'], 'Ref' => 'AWS::AccountId'
  end
end
