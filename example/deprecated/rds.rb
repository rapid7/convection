#!/usr/bin/env ruby
require 'convection'

rds_template = Convection.template do
  description 'Testing RDS DB Instance definition'

  param_group = parameter_group 'TestingParamGroup' do
    description 'My Parameter Group for test the app' # Required
    family 'MySQL5.6' # Required
    parameters({
      character_set_database: 'utf8',
      slow_query_log: 1,
      max_allowed_packet: 10485760,
      lower_case_table_names: 1,
      innodb_flush_method: 'O_DIRECT',
      log_warnings: 2,
      collation_connection: 'utf8_unicode_ci',
      collation_server: 'utf8_unicode_ci',
      long_query_time: 5,
      character_set_server: 'utf8',
      log_output: 'FILE'
    })
    tag 'ui-test-db-param-group', 'yep'
  end

  #sec_group = db_security_group 'TestingSecurityGroup' do
  #  ec2_vpc_id 'vpc-98248' #Required
  #  db_security_group_ingress # Required
  #  group_description # Required
  #  tag 'ui-test-db-sec-group', 'yep'
  #end

  subnet_group = db_subnet_group 'TestingSubnetGroup' do
    db_subnet_group_description 'SubnetGroup for Testing ENV'
    subnet_id 's-1345345'
    subnet_id 's-23566'
  end

  db_master = db_instance 'TestDBMasterInstance' do
    allocated_storage '250' # Required
    backup_retention_period '7'
    db_instance_class 'db.m3.2xlarge' # Required
    db_instance_identifier 'ui-test-db'
    db_parameter_group_name param_group.name
    db_subnet_group_name subnet_group.name
    engine 'MySQL'
    iops '1000'
    master_username 'ui-test-db-user'
    master_user_password 'ui-test-db-password'
    multi_az true
#    vpc_security_groups fn_ref(sec_group.name)
    tag 'ui-test-db', 'yep'
  end

  db_instance 'TestDBReplicaInstance' do
    source_db_instance_identifier db_master.properties['DBInstanceIdentifier']
    allocated_storage '250' # Required
    db_instance_class 'db.m3.2xlarge' # Required
    db_instance_identifier "#{db_master.properties['DBInstanceIdentifier']}-replica"
    db_parameter_group_name param_group.name
    db_subnet_group_name subnet_group.name
    engine 'MySQL'
    iops '1000'
#    vpc_security_groups fn_ref(sec_group.name)
    tag 'ui-test-db-replica', 'yep'
  end
end

puts rds_template.to_json
# puts Convection.stack('S3TestStack', s3_template, :region => 'us-west-1').apply
