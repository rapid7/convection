require 'simplecov'
SimpleCov.start do
  add_group 'Control', 'lib/convection/control'
  add_group 'Model', 'lib/convection/model'
  add_group 'DSL', 'lib/convection/dsl'
end

gem 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/convection'
