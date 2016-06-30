require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rake/testtask'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/test_*.rb'
end
RSpec::Core::RakeTask.new(:spec)

task :default => [:test, :spec, :rubocop]
