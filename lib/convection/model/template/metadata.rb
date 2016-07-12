module Convection
  module Model
    class Template
      class Metadata
        attr_accessor :name
        attr_accessor :value

        def initialize(name, value)
          @name = name
          @value = value
        end

        def render
          value
        end
      end
    end
  end
end
