require 'active_support/core_ext/string/inflections'

module Convection
  module DSL
    module TerraformIntrinsicFunctions
      def base64(content)
        %q(base64(#{content.to_json}))
      end

      def fn_and(*)
        warn "WARNING: Condition functions cannot be inferred when migrating to terraform. Please set count on migrated resources manually. #{self.class}(#{name})"
        "${todo.fn_and.ATTRIBUTE.set_in_count}"
      end

      def fn_equals(*)
        warn "WARNING: Condition functions cannot be inferred when migrating to terraform. Please set count on migrated resources manually. #{self.class}(#{name})"
        "${todo.fn_equals.ATTRIBUTE.set_in_count}"
      end

      def fn_if(*)
        warn "WARNING: Condition functions cannot be inferred when migrating to terraform. Please set count on migrated resources manually. #{self.class}(#{name})"
        "${todo.fn_if.ATTRIBUTE.set_in_count}"
      end

      def fn_import_value(*)
        warn "WARNING: Fn::ImportValue cannot be inferred when migrated to terraform. Please pull in this input through a variable or local value in your configuration. #{self.class}(#{name})"
        "${todo.fn_import_value.ATTRIBUTE}"
      end

      def fn_not(*)
        warn "WARNING: Condition functions cannot be inferred when migrating to terraform. Please set count on migrated resources manually. #{self.class}(#{name})"
        "${todo.fn_not.ATTRIBUTE.set_in_count}"
      end

      def fn_or(*)
        warn "WARNING: Condition functions cannot be inferred when migrating to terraform. Please set count on migrated resources manually. #{self.class}(#{name})"
        "${todo.fn_or.ATTRIBUTE.set_in_count}"
      end

      def fn_sub(*)
        warn "WARNING: Fn::Sub cannot be inferred when migrating to terraform. Please use ${replace(str, search, replace)} instead. #{self.class}(#{name})"
        "${replace(todo.fn_sub.STRING, todo.fn_sub.SEARCH, todo.fn_sub.REPLACE)}"
      end

      def find_in_map(*)
        warn "WARNING: Fn::FindInMap cannot be inferred when migrating to terraform. Please consult with the interpolation syntax terraform docs #{self.class}(#{name})"
        "${lookup(lookup(YOUR_MAP, YOUR_TOP_LEVEL_KEY), YOUR_NESTED_KEY)}"
      end

      def get_att(resource_name, attr_name)
        interpolation_string = "${#{terraform_resource_type(resource_name)}.#{terraform_resource_name(resource_name)}.#{attr_name.underscore}}"
        warn "WARNING: Inferring you want to use #{interpolation_string} in place of Fn::GetAtt. Please consult with the interpolation syntax terraform docs and docs for this resource type in terraform to verify compatablity. #{self.class}(#{name})"
        interpolation_string
      end

      def get_azs(*)
        warn "WARNING: Inferring you want to use ${var.availability_zones} instead of Fn::GetAZs. Please consult with the interpolation syntax terraform docs to verify compatablity. Additionally you should attempt to use variables in place of a literal list. #{self.class}(#{name})"
        "${var.availability_zones}"
      end

      def join(delimiter, *values)
        interpolation_string = "${join(\"#{delimiter}\", list(#{values.map { |o| "\"#{o}\"" }.join(', ')}))"
        warn "WARNING: Inferring you want to use #{interpolation_string} in place of Fn::Join. Please consult with the interpolation syntax terraform docs to verify compatablity. Additionally you should attempt to use variables in place of a literal list. #{self.class}(#{name})"
        interpolation_string
      end

      def select(index, *objects)
        interpolation_string = "${element(list(#{objects.map { |o| "\"#{o}\"" }.join(', ')}), #{index})"
        warn "WARNING: Inferring you want to use #{interpolation_string} in place of Fn::Select. Please consult with the interpolation syntax terraform docs to verify compatablity. Additionally you should attempt to use variables in place of a literal list. #{self.class}(#{name})"
        interpolation_string
      end

      def fn_ref(resource_name)
        interpolation_string = "${#{terraform_resource_type(resource_name)}.#{terraform_resource_name(resource_name)}.id}"
        warn "WARNING: Inferring you want to use #{interpolation_string} in place of Fn::Ref. Please consult with the interpolation syntax terraform docs and docs for this resource type in terraform to verify compatablity. #{self.class}(#{name})"
        interpolation_string
      end

      def terraform_resource_name(resource_name)
        resource_name.underscore
      end

      def terraform_resource_type(resource_name)
        return type.sub(/^AWS::/, 'aws_').underscore if respond_to?(:type)
        return resources[resource_name].type.underscore if respond_to?(:resources) && resources[resource_name]
        return all_resources[resource_name].type.underscore if respond_to?(:all_resources) && all_resources[resource_name]
        return parent.resources[resource_name].type.underscore if respond_to?(:parent) && parent.resources[resource_name]

        'todo_fixme_see_resource_type'
      end
    end
  end
end
