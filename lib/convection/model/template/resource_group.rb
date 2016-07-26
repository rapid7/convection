require_relative './resource'

module Convection
  module Model
    class Template
      # A collection of different {Convection::Model::Template::Resource}s.
      class ResourceGroup
        include DSL::Helpers
        include DSL::IntrinsicFunctions
        include DSL::Template::Resource

        attr_reader :name
        attr_reader :parent
        attr_reader :template

        def initialize(name, parent, &block)
          @name = name
          @parent = parent
          @template = parent.template

          instance_exec(&block) if block
        end

        def resources
          @resources ||= Convection::Model::Collection.new
        end

        def resource_group(*)
          fail NotImplementedError, "#{self.class}#resource_group is not yet implemented."
        end
      end
    end
  end
end
