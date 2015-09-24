require 'test_helper'
require 'json'
require 'pp'

class TestConditions < Minitest::Test
  def setup
    # Inspired by http://www.unixdaemon.net/cloud/intro-to-cloudformations-conditionals.html
    @template = ::Convection.template do
      description 'Conditions Test Template'

      parameter 'DeploymentEnvironment' do
        type 'String'
        description 'The environment this stack is being deployed to.'
        default 'dev'

        allow 'dev'
        allow 'stage'
        allow 'prod'
      end

      condition 'InProd' do
        fn_equals(fn_ref('DeploymentEnvironment'), 'prod')
      end

      condition 'NotInProd' do
        fn_or(
          fn_equals(fn_ref('DeploymentEnvironment'), 'stage'),
          fn_equals(fn_ref('DeploymentEnvironment'), 'dev')
        )
      end

      resource 'SomeSG' do
        type 'AWS::EC2::SecurityGroup'
        condition 'NotInProd'
      end

      resource 'SQLDB' do
        type 'AWS::RDS::DBInstance'
        property 'Iops', fn_if('InProd', '1000', fn_ref('AWS::NoValue'))
      end
    end
  end

  def from_json
    JSON.parse(@template.to_json)
  end

  def test_inprod_condition
    # Expected JSON:
    # "InProd": { "Fn::Equals" : [ { "Ref" : "DeploymentEnvironment" }, "prod" ] },
    json = from_json['Conditions']['InProd']
    func_args = json['Fn::Equals']

    assert func_args.is_a? Array
    assert_equal 2, func_args.size

    perform_parameter_ref_comparison func_args, 'DeploymentEnvironment', 'prod'
  end

  def test_notinprod_condition
    # Expected JSON:
    # "NotInProd": {
    #   "Fn::Or" : [
    #     { "Fn::Equals" : [ { "Ref" : "DeploymentEnvironment"}, "stage" ] },
    #     { "Fn::Equals" : [ { "Ref" : "DeploymentEnvironment"}, "dev" ] }
    #   ]
    #  }
    json = from_json['Conditions']['NotInProd']
    func_args = json['Fn::Or']

    assert func_args.is_a? Array
    assert_equal 2, func_args.size

    subfunc1 = func_args[0]['Fn::Equals'] # check for 'stage'
    subfunc2 = func_args[1]['Fn::Equals'] # check for 'dev'

    perform_parameter_ref_comparison subfunc1, 'DeploymentEnvironment', 'stage'
    perform_parameter_ref_comparison subfunc2, 'DeploymentEnvironment', 'dev'
  end

  def test_resource_uses_condition
    json = from_json['Resources']['SomeSG']

    assert json.is_a? Hash
    assert json.key? 'Condition'
    assert_equal 'NotInProd', json['Condition']
  end

  def test_property_uses_condition
    iops_property = from_json['Resources']['SQLDB']['Properties']['Iops']
    # Expected JSON:
    # "Iops" : { "Fn::If" : [ "InProd", "1000", { "Ref" : "AWS::NoValue" }

    # Check we have an IF function
    assert iops_property.is_a? Hash
    assert_equal 1, iops_property.size
    assert iops_property.key? 'Fn::If'

    # Check the 3 arguments to the IF function: (condition, true_value, false_value)
    if_cond = iops_property['Fn::If']
    assert if_cond.is_a? Array
    assert_equal 3, if_cond.size

    assert_equal 'InProd', if_cond[0]
    assert_equal '1000', if_cond[1]
    assert if_cond[2].is_a? Hash
    assert_equal 'AWS::NoValue', if_cond[2]['Ref']
  end

  private

  def perform_parameter_ref_comparison(comparison_array, parameter_name, expected_value)
    parameter_ref = comparison_array[0]
    assert parameter_ref.is_a? Hash
    assert_equal 1, parameter_ref.size
    assert parameter_ref.key? 'Ref'
    assert parameter_ref.value? parameter_name

    assert_equal expected_value, comparison_array[1]
  end
end
