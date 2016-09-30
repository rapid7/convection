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
        attribute :export_as
        attr_reader :template

        def initialize(name, parent)
          @name = name
          @template = parent.template

          @type = ''
          @properties = {}
        end

        def render
          {
            'Value' => value.respond_to?(:render) ? value.render : value,
            'Description' => description
          }.tap do |output|
            render_condition(output)
            output['Export'] = { 'Name' => export_as } if export_as
          end
        end
      end
    end
  end
end
