module Convection
  module Model
    class Template
      # Base class for {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-product-property-reference.html Resource Property Types}
      class ResourceProperty
        class << self
          def properties
            @properties ||= {}
          end

          def property(accesor, property_name, options = {})
            properties[accesor] = Resource::Property.create(accesor, property_name, options)
            properties[accesor].attach(self)
          end

          def attach_method(name, &block)
            define_method(name, &block)
          end
        end

        include DSL::Helpers

        ##
        # Resource Property Instance Methods
        ##
        attr_reader :template
        attr_reader :properties
        attr_reader :exist
        alias_method :exist?, :exist

        def initialize(parent)
          @template = parent.template
          @exist = false

          ## Instantiate properties
          @properties = Model::Collection.new
          resource = self
          resource.class.properties.each do |_, property|
            @properties[property.property_name] = property.instance(resource)
          end
        end

        def property(key, *value)
          return properties[key].value if value.empty?

          ## Define a property instance on the fly
          properties[key] = ScalarPropertyInstance.new(self) unless properties.include?(key)
          properties[key].set(*value)
        end

        def render
          properties.map(true, &:render)
        end
      end
    end
  end
end

## Require all resource properties
Dir.glob(File.expand_path('../resource_property/*.rb', __FILE__)) do |r|
  require_relative r
end
