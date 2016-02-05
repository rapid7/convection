# nodoc
module Convection
  VERSION = IO.read(File.expand_path('../../../VERSION', __FILE__)) rescue '0.0.1'
  SUMMARY = 'A fully generic, modular DSL for AWS CloudFormation'.freeze
  DESCRIPTION = IO.read(File.expand_path('../../../README.md', __FILE__)) rescue ''
end
