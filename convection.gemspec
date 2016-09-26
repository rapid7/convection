# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'convection/version'

Gem::Specification.new do |spec|
  spec.name          = 'convection'
  spec.version       = Convection::VERSION
  spec.authors       = ['John Manero']
  spec.email         = ['jmanero@rapid7.com']
  spec.summary       = %q{A fully generic, modular DSL for AWS CloudFormation}
  spec.description   = %q{This gem aims to provide a reusable model for AWS CloudFormation in Ruby. It exposes a DSL for template definition, and a simple, decoupled abstraction of a CloudFormation Stack to compile and apply templates.}
  spec.homepage      = 'https://github.com/rapid7/convection'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^exe\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk', '>= 2'
  spec.add_runtime_dependency 'httparty', '~> 0.13'
  spec.add_runtime_dependency 'netaddr', '~> 1.5'
  spec.add_runtime_dependency 'thor', '~> 0.19'
end
