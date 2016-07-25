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

          template.attach_resource(@name, self.class)
          instance_exec(&block) if block
        end

        def render(stack)
          resources.map do |resource|
            if resource.is_a?(Convection::Model::Template::CustomResource)
              resource.render(stack)
            else
              # TODO: Just make Resource#render accept stack as a [today] unused argument?
              resource.render
            end
          end
        end

        def resources
          @resources ||= template.resources.dup
        end
      end
    end
  end
end
