require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'yard'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :rubocop]
task :yardoc do
  sh 'yardoc -e yard_extensions.rb'
end
