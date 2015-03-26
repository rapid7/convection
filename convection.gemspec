# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'convection/version'

Gem::Specification.new do |spec|
  spec.name          = 'convection'
  spec.version       = Convection::VERSION
  spec.authors       = ['John Manero']
  spec.email         = ['jmanero@rapid7.com']
  spec.summary       = Convection::SUMMARY
  spec.description   = Convection::DESCRIPTION
  spec.homepage      = 'https://github.com/rapid7/convection'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'thor-scmversion', '= 1.7.0'
  spec.add_development_dependency 'minitest'

  spec.add_runtime_dependency 'aws-sdk', '>= 2'
  spec.add_runtime_dependency 'netaddr', '~> 1.5.0'
  spec.add_runtime_dependency 'thor', '~> 0.19.1'
end
