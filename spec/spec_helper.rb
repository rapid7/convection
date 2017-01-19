require 'simplecov'
SimpleCov.start do
  add_group 'Control', 'lib/convection/control'
  add_group 'Model', 'lib/convection/model'
  add_group 'DSL', 'lib/convection/dsl'
end

require_relative '../lib/convection'
require_relative '../lib/convection/model/cloudfile'
require_relative './cf_client_context'
require_relative './collect_availability_zones_task_context'
require_relative './ec2_client_context'
