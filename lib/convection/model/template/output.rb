require_relative '../../dsl/intrinsic_functions'
require_relative '../mixin/conditional'

module Convection
  module Model
    class Template
      ##
      # Resource
      ##
      class Output
        extend DSL::Helpers
        include DSL::IntrinsicFunctions
        include Model::Mixin::Conditional

        attribute :value
        attribute :description

        def initialize(name, template)
          @name = name
          @template = template

          @type = ''
          @properties = {}
        end

        def render
          {
            'Value' => value,
            'Description' => description
          }.tap do |resource|
            render_condition(resource)
          end
        end
      end
    end
  end
end
