require 'forwardable'
require_relative './resource'
require_relative '../mixin/conditional'

module Convection
  module Model
    class Template
      # A collection of different {Convection::Model::Template::Resource}s.
      class ResourceGroup
        extend Forwardable
        include DSL::Helpers
        include DSL::Template::Resource
        include Mixin::Conditional

        attr_reader :name
        attr_reader :parent
        attr_reader :template

        def_delegator :@template, :stack

        def initialize(name, parent, &definition)
          @definition = definition
          @name = name
          @parent = parent
          @template = parent.template
        end

        def execute
          instance_exec(&@definition)
        end

        def resource_group(*)
          fail NotImplementedError, "#{self.class}#resource_group is not yet implemented."
        end

        def resources
          @resources ||= Convection::Model::Collection.new
        end
      end
    end
  end
end
