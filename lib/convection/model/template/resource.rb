require_relative '../../dsl/intrinsic_functions'
require_relative '../mixin/cidr_block'
require_relative '../mixin/conditional'
require_relative '../mixin/policy'
require_relative '../mixin/protocol'
require_relative '../mixin/taggable'
require_relative './output'

module Convection
  module Model
    class Template
      ##
      # Resource
      ##
      class Resource
        class << self
          def properties
            @properties ||= {}
          end

          def type(cf_type = nil, dsl_name = nil)
            return @type if cf_type.nil?

            @type = cf_type
            @name = dsl_name || DSL::Helpers.method_name(cf_type)

            DSL::Template::Resource.attach_resource(@name, self)
          end

          def property(accesor, property_name, options = {})
            ## Handle usage of old property interface
            options = {}.tap do |o|
              o[:type] = options
            end if options.is_a?(Symbol)

            properties[accesor] = Property.create(accesor, property_name, options)
            properties[accesor].attach(self)
          end

          def attach_method(name, &block)
            define_method(name, &block)
          end
        end

        ##
        # Validation and intraspection for resource properties
        ##
        class Property
          attr_reader :name
          attr_reader :property_name
          attr_reader :default
          attr_reader :transform

          attr_reader :immutable
          alias_method :immutable?, :immutable
          attr_reader :required
          attr_reader :equal_to
          attr_reader :kind_of
          attr_reader :regex

          class << self
            ## Switch between Scalar and List
            def create(name, property_name, options = {})
              case options[:type]
              when :string, :scalar, nil then ScalarProperty.new(name, property_name, options)
              when :array, :list then ListProperty.new(name, property_name, options)
              when :hash then HashProperty.new(name, property_name, options)
              else fail TypeError, "Property must be defined with type `string` or `array`, not #{ options[:type] }"
              end
            end
          end

          def initialize(name, property_name, options = {})
            @name = name
            @property_name = property_name
            @default = options[:default]
            @transform = options.fetch(:transform, []).is_a?(Array) ? options.fetch(:transform, []) : [options[:transform]]

            @immutable = options[:immutable].is_a?(TrueClass)
            @required = options.fetch(:required, false)
            @equal_to = options.fetch(:equal_to, []).is_a?(Array) ? options.fetch(:equal_to, []) : [options[:equal_to]]
            @kind_of = options.fetch(:kind_of, []).is_a?(Array) ? options.fetch(:kind_of, []) : [options[:kind_of]]
            @regex = options.fetch(:regex, false)
          end
        end

        ##
        # An instance of a poperty in a resoruce
        ##
        class PropertyInstance
          attr_reader :resource
          attr_reader :property
          attr_reader :value
          attr_accessor :current_value

          def initialize(resource, property = nil)
            @resource = resource
            @property = property
          end

          def transform(value)
            return value if property.nil?
            property.transform.inject(value) { |a, e| resource.instance_exec(a, &e) }
          end

          def validate!(value)
            return value if property.nil?

            if resource.exist? && property.immutable && current_value != value
              fail ArgumentError,
                   "Property #{ property.name } is immutable!"
            end

            if property.required && value.nil?
              fail ArgumentError,
                   "Property #{ property.name } is required!"
            end

            unless property.equal_to.empty? || property.equal_to.include?(value)
              fail ArgumentError,
                   "Property #{ property.name } must be one of #{ property.equal_to.join(', ') }!"
            end

            unless property.kind_of.empty? || property.kind_of.any? { |t| value.is_a?(t) }
              fail ArgumentError,
                   "Property #{ property.name } must be one of #{ property.kind_of.join(', ') }!"
            end

            unless !property.regex || property.regex.match(value.to_s)
              fail ArgumentError,
                   "Property #{ property.name } must match #{ property.regex.inspect }!"
            end

            value
          end

          def default
            return if property.nil?
            property.default
          end

          def current(val)
            @current_value = @value = val
          end
        end

        ##
        # A Scalar Property
        ##
        class ScalarProperty < Property
          def attach(resource)
            definition = self ## Expose to resource instance closure

            resource.attach_method(definition.name) do |value = nil|
              return properties[definition.property_name].value if value.nil?
              properties[definition.property_name].set(value)
            end

            resource.attach_method("#{ definition.name }=") do |value|
              properties[definition.property_name].set(value)
            end
          end

          def instance(resource)
            ScalarPropertyInstance.new(resource, self)
          end
        end

        ##
        # Instance of a scalar property
        ##
        class ScalarPropertyInstance < PropertyInstance
          def set(new_value)
            @value = validate!(transform(new_value))
          end

          def render
            return default if value.nil?
            return value.reference if value.is_a?(Resource)
            value.respond_to?(:render) ? value.render : value
          end
        end

        ##
        # A Hash Property
        ##
        class HashProperty < Property
          def attach(resource)
            definition = self ## Expose to resource instance closure

            resource.attach_method(definition.name) do |key, value = nil|
              properties[definition.property_name].set(key, value)
            end
          end

          def instance(resource)
            HashPropertyInstance.new(resource, self)
          end
        end

        ##
        # Instance of a hash property
        ##
        class HashPropertyInstance < PropertyInstance
          def initialize(*_)
            super

            @value = {}
            @current_value = {}
          end

          def set(key, new_value)
            @value[key] = validate!(transform(new_value))
          end

          def render
            value.keys.each_with_object({}) do |i, memo|
              memo[i] = if value[i].is_a?(Resource)
                          value[i].reference
                        elsif value[i].respond_to?(:render)
                          value[i].render
                        else
                          value[i]
                        end
            end
          end
        end

        ##
        # A List Property
        ##
        class ListProperty < Property
          def attach(resource)
            definition = self ## Expose to resource instance closure

            resource.attach_method(definition.name) do |*values|
              properties[definition.property_name].set(values.flatten) unless values.empty?

              ## Return the list
              properties[definition.property_name].value
            end
          end

          def instance(resource)
            ListPropertyInstance.new(resource, self)
          end
        end

        ##
        # Instance of a list property
        ##
        class ListPropertyInstance < PropertyInstance
          def initialize(*_)
            super

            @value = []
            @current_value = []
          end

          def set(values)
            values.map! do |new_value|
              validate!(transform(new_value))
            end

            @value.push(*values)
          end
          alias_method :<<, :set
          alias_method :push, :set

          def render
            return default if value.nil? || value.empty?
            value.map do |val|
              next val.reference if val.is_a?(Resource)
              val.respond_to?(:render) ? val.render : val
            end
          end
        end

        include DSL::Helpers
        include DSL::Template::Resource
        include Mixin::Conditional

        ##
        # Resource Instance Methods
        ##
        attribute :type
        attr_reader :name
        attr_reader :parent
        attr_reader :template
        attr_reader :properties
        attr_reader :resource_attributes
        attr_reader :exist
        alias_method :exist?, :exist

        def initialize(name, parent)
          @name = name
          @parent = parent
          @template = parent.template
          @type = self.class.type
          @depends_on = []
          @deletion_policy = nil
          @exist = false

          @resource_attributes = []

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

        def depends_on(resource)
          @depends_on << (resource.is_a?(Resource) ? resource.name : resource)
        end

        # rubocop:disable Style/TrivialAccessors
        #   We don't want to use an accessor (e.g. deletion_policy=) because
        #   this is a DSL method
        def deletion_policy(deletion_policy)
          @deletion_policy = deletion_policy
        end
        # rubocop:enable Style/TrivialAccessors

        def reference
          {
            'Ref' => name
          }
        end

        def with_output(output_name = name, value = reference, export_as: nil, &block)
          o = Model::Template::Output.new(output_name, @template)
          o.value = value
          o.description = "Resource #{ type }/#{ name }"
          o.export_as = export_as if export_as

          o.instance_exec(&block) if block
          @template.outputs[output_name] = o
        end

        def as_attribute(attr_name, attr_type = :string)
          @template.attribute_mappings[name] = {
            :name => attr_name,
            :type => attr_type
          }
        end

        def render
          {
            'Type' => type,
            'Properties' => properties.map(true, &:render)
          }.tap do |resource|
            resource_attributes.map { |a| a.render resource }
            resource['DependsOn'] = @depends_on unless @depends_on.empty?
            resource['DeletionPolicy'] = @deletion_policy unless @deletion_policy.nil?
            render_condition(resource)
          end
        end
      end
    end
  end
end

## Require all resources
Dir.glob(File.expand_path('../resource/*.rb', __FILE__)) do |r|
  require_relative r
end
