require 'forwardable'
require_relative './intrinsic_functions'

module Convection
  module DSL
    ##
    # Methods for defining DSL/Models
    ##
    module ClassHelpers
      def attribute(attribute_name)
        attr_writer attribute_name
        define_method(attribute_name) do |value = nil|
          instance_variable_set("@#{ attribute_name }", value) unless value.nil?
          instance_variable_get("@#{ attribute_name }")
        end
      end

      def list(attribute_name)
        define_method(attribute_name) do |value = nil|
          collection = instance_variable_get("@#{ attribute_name }")
          collection << value unless value.nil?
          collection
        end
      end
    end

    ##
    # Helper methods for creating templates
    ##
    module Helpers
      extend Forwardable
      include DSL::IntrinsicFunctions

      def_delegators :@template, :stack, :parameters, :mappings, :resources, :outputs

      class << self
        def included(mod)
          mod.extend(DSL::ClassHelpers)
        end

        def method_name(cf_type)
          nodes = cf_type.split('::')
          nodes.shift # Remove AWS::

          ## Cammel-case to snake-case
          nodes.map! do |n|
            n.split(/([A-Z0-9])(?![A-Z0-9])(?<!$)/)
              .reject(&:empty?)
              .reduce('') { |a, e| (e.length == 1 && !a.empty?) ? a + "_#{e}" : a + e }
              .downcase
          end

          nodes.join('_').downcase
        end
      end

      ## Convert various casings to CamelCase
      def camel_case(str)
        str.downcase.split(/[\.\-_]/).map(&:capitalize).join
      end

      ## Convert various casings to snake_case
      def snake_case(str)
        str.downcase.split(/[\.\-_]/).join('_')
      end

      ## Convert various casings to SCREAMING_SNAKE_CASE
      def screaming_snake_case(str)
        str.upcase.split(/[\.\-_]/).join('_')
      end
    end
  end
end
