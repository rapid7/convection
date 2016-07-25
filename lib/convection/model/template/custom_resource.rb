require_relative './resource'

module Convection
  module Model
    class Template
      # TODO: We've been back on forth on the name for this concept.
      # Is CustomResource *really* better than ResourceGroup?
      class CustomResource
        include DSL::Helpers
        include DSL::IntrinsicFunctions
        include DSL::Template::Resource

        attribute :type
        attr_reader :name
        attr_reader :parent
        attr_reader :template

        def initialize(name, parent, &block)
          @name = name
          @parent = parent
          @template = parent.template

          instance_exec(&block) if block
        end

        def render(stack)
          resources.map { |resource| resource.render(stack) }
        end

        def resources
          @resources ||= Convection::Model::Collection.new
        end
      end
    end
  end
end
