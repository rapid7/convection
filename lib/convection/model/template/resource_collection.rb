require 'forwardable'
require_relative './resource'
require_relative '../mixin/conditional'

module Convection
  module Model
    class Template
      # A collection of different {Convection::Model::Template::Resource}s.
      class ResourceCollection
        extend Forwardable
        include DSL::Helpers
        include DSL::Template::Resource
        include Mixin::Conditional

        attr_reader :name
        attr_reader :parent
        attr_reader :template

        def_delegator :@template, :stack

        class << self
          def attach_to_dsl(dsl_name)
            DSL::Template::Resource.attach_resource_collection(dsl_name, self)
          end
        end

        def initialize(name, parent, &definition)
          @definition = definition
          @name = name
          @parent = parent
          @template = parent.template
        end

        # @note This method is in place to be overriden by subclasses.
        def execute
        end

        def run_definition
          instance_exec(&@definition) if @definition
        end

        def resources
          @resources ||= Convection::Model::Collection.new
        end
      end
    end
  end
end
