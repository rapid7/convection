require 'json'
require_relative '../../dsl/intrinsic_functions'
require_relative '../mixin/conditional'

module Convection
  module Model
    class Template
      ##
      # Resource
      ##
      class Output
        include DSL::Helpers
        include Model::Mixin::Conditional

        attribute :name
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
            'Value' => value.is_a?(Array) ? JSON.generate(value) : value,
            'Description' => description
          }.tap do |output|
            render_condition(output)
          end
        end
      end
    end
  end
end
