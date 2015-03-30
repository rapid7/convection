require_relative '../../dsl/intrinsic_functions'

module Convection
  module Model
    ##
    # Hash with auto-generating sparse keys
    ##
    class Smash < Hash
      def initialize(*args)
        super do |hash, key|
          hash[key] = Smash.new
        end
      end
    end

    class Template
      ##
      # Mapping
      ##
      class Mapping
        include DSL::Helpers
        include DSL::IntrinsicFunctions

        attr_reader :items

        def initialize(name, template)
          @name = name
          @template = template

          @items = Smash.new
        end

        def item(key_1, key_2, value)
          items[key_1][key_2] = value
        end

        def render
          items
        end
      end
    end
  end
end
