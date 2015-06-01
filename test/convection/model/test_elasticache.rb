require 'test_helper'
require 'json'
require 'pp'

class TestElasticache < Minitest::Test
  def setup
    # Inspired by http://www.unixdaemon.net/cloud/intro-to-cloudformations-conditionals.html
    @template = ::Convection.template do
      description 'Elasticache Test Template'

      ec2_security_group 'MyEC2SecGroup' do
        ingress_rule(:tcp, 22, 'my.ip.address')
      end

      elasticache_security_group 'MyRedisSecGroup' do
        description 'Redis cache security group'
      end

      elasticache_security_group_ingress 'MyRedisSecGroupIngress' do
        cache_security_group_name fn_ref('MyRedisSecGroup')
        ec2_security_group_name(fn_ref('MyEC2SecGroup'))
        ec2_security_group_owner_id('123456789012')
      end

      elasticache_parameter_group 'MyRedisParmGroup' do
        cache_parameter_group_family 'redis2.8'
        description 'Redis cache parameter group'
        parameter 'my_parm_key', 'my_parm_value'
      end

      elasticache_cache_cluster 'MyRedisCluster' do
        cluster_name "demo"

        auto_minor_version_upgrade true
        cache_node_type 'cache.m3.medium'
        cache_parameter_group_name fn_ref('MyRedisParmGroup')
        cache_security_group_names [ fn_ref('MyRedisSecGroup') ]
        engine 'redis'
        engine_version '2.8.6'
        num_cache_nodes 1
      end

    end
  end

  def from_json
    JSON.parse(@template.to_json)
  end

  def test_elasticache_instance
    json = from_json['Resources']['MyRedisCluster']
    secgroups = json['Properties']['CacheSecurityGroupNames']

    assert secgroups.is_a? Array
    assert_equal 1, secgroups.size

    perform_parameter_ref_comparison secgroups, 'MyRedisSecGroup', nil
  end

  def test_elasticache_secgroup_ingress
    json = from_json['Resources']['MyRedisSecGroupIngress']
    cachesecgroup = json['Properties']['CacheSecurityGroupName']

    assert cachesecgroup.is_a? Hash
    assert_equal 1, cachesecgroup.size
    assert cachesecgroup.has_key? 'Ref'
    assert cachesecgroup.has_value? 'MyRedisSecGroup'

    ec2_secgroup = json['Properties']['EC2SecurityGroupName']
    assert ec2_secgroup.is_a? Hash
    assert_equal 1, ec2_secgroup.size
    assert ec2_secgroup.has_key? 'Ref'
    assert ec2_secgroup.has_value? 'MyEC2SecGroup'
  end

  def test_elasticache_secgroup_ingress
    json = from_json['Resources']['MyRedisParmGroup']
    parms = json['Properties']['Properties']

    assert parms.is_a? Hash
    assert_equal 1, parms.size
    assert parms.has_key? 'my_parm_key'
    assert parms.has_value? 'my_parm_value'
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
