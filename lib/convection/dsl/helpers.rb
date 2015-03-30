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

      # def child(child_name, klass, options = {}, &block)
      #   attr_reader collection
      #   define_method(child_name) do |instance_name, &instance_block|
      #     resource = klass.new(instance_name, self)
      #     resource.instance_exec(&instance_block) if instance_block
      #
      #     instance_exec(resource, &block) if block
      #     instance_variable_get("@#{ options[:collection] }")[instance_name] = resource if options.include?(:collection)
      #   end
      # end
    end

    ##
    # Helper methods for creating templates
    ##
    module Helpers
      class << self
        def included(mod)
          mod.extend(DSL::ClassHelpers)
        end
      end

      def camelize(str)
        str.split('-').map!(&:capitalize).join
      end

      def stack
        @template.stack
      end
    end
  end
end
