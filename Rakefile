require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'yard'
require_relative './yard_extensions'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new

task :default => [:spec, :rubocop]
