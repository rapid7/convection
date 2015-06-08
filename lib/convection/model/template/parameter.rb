require_relative '../../dsl/intrinsic_functions'

module Convection
  module Model
    class Template
      ##
      # Template Parameter
      ##
      class Parameter
        include DSL::Helpers

        attribute :type
        attribute :default
        attribute :description
        attr_reader :template

        attr_reader :allowed_values
        attribute :allowed_pattern
        attribute :no_echo
        attribute :max_length
        attribute :min_length
        attribute :max_value
        attribute :min_value
        attribute :constraint_description

        def initialize(name, parent)
          @name = name
          @template = parent.template

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
            resource['AllowedPattern'] = allowed_pattern unless allowed_pattern.nil?
            resource['MaxLength'] = max_length unless max_length.nil?
            resource['MinLength'] = min_length unless min_length.nil?
            resource['MaxValue'] = max_value unless max_value.nil?
            resource['MinValue'] = min_value unless min_value.nil?
            resource['NoEcho'] = no_echo unless no_echo.nil?
            resource['ConstraintDescription'] = constraint_description unless constraint_description.nil?
          end
        end
      end
    end
  end
end
