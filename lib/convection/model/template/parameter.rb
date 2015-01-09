require_relative '../../dsl/intrinsic_functions'

module Convection
  module Model
    class Template
      ##
      # Template Parameter
      ##
      class Parameter
        extend DSL::Helpers
        include DSL::IntrinsicFunctions

        attribute :type
        attribute :default
        attribute :description
        attr_reader :allowed_values

        def initialize
          @type = 'String'
          @default = ''
          @allowed_values = []
          @description = ''
        end

        def allow(value)
          allowed_values << value
        end

        def render
          {
            'Type' => type,
            'Default' => default,
            'Description' => description
          }.tap do |resource|
            resource['AllowedValues'] = allowed_values unless allowed_values.empty?
          end
        end
      end
    end
  end
end
