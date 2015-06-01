require 'test_helper'
require 'json'
require 'pp'

class TestRDS < Minitest::Test
  def setup
    # Inspired by http://www.unixdaemon.net/cloud/intro-to-cloudformations-conditionals.html
    @template = ::Convection.template do
      description 'RDS Test Template'

      rds_security_group 'MyRDSSecGroup' do
        description "Pulls in EC2 SGs"
        security_group_ingress do
          ec2_security_group('MyEC2SecGroup', '123456789012')
        end
        security_group_ingress do
          cidr_ip 'my_cidr_value'
        end
      end

      rds_instance 'MyRDSInstance' do
        engine 'MySQL'
        instance_class 'db.m1.medium'
        allocated_storage 5
        backup_retention_period 7
        multi_az false

        master_username 'root'
        master_password 'secret'

        security_group [ fn_ref('MyRDSSecGroup') ]
      end
    end
  end

  def from_json
    JSON.parse(@template.to_json)
  end

  def test_rds_instance
    # Expected JSON: 
    json = from_json['Resources']['MyRDSInstance']
    db_secgroups = json['Properties']['DBSecurityGroups']

    assert db_secgroups.is_a? Array
    assert_equal 1, db_secgroups.size

    perform_parameter_ref_comparison db_secgroups, 'MyRDSSecGroup', nil
  end

  def test_rds_secgroup
    # Expected JSON: 
    json = from_json['Resources']['MyRDSSecGroup']
    ingress_rules = json['Properties']['DBSecurityGroupsIngress']

    assert ingress_rules.is_a? Array
    assert_equal 2, ingress_rules.size

    ingress_rules.each do |rule|
      if rule.has_key? 'CIDRIP'
        assert rule.has_value?  'my_cidr_value'
      else
        assert rule['EC2SecurityGroupName'] == 'MyEC2SecGroup'
        assert rule['EC2SecurityGroupOwnerId'] == '123456789012'
      end
    end

    perform_parameter_ref_comparison db_secgroups, 'MyRDSSecGroup', nil
  end

  private

  def perform_parameter_ref_comparison(comparison_array, parameter_name, expected_value)
    parameter_ref = comparison_array[0]
    assert parameter_ref.is_a? Hash
    assert_equal 1, parameter_ref.size
    assert parameter_ref.has_key? 'Ref'
    assert parameter_ref.has_value? parameter_name

    assert_equal expected_value, comparison_array[1]
  end
end
