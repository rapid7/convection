module Convection
  module DSL
    ##
    # Formatting helpers for Intrinsic Functions
    module IntrinsicFunctions
      def base64(content)
        {
          'Fn::Base64' => content
        }
      end

      def fn_and(*conditions)
        {
          'Fn::And' => conditions
        }
      end

      def fn_equals(value_1, value_2)
        {
          'Fn::Equals' => [value_1, value_2]
        }
      end

      def fn_if(condition, value_true, value_false)
        {
          'Fn::If' => [condition, value_true, value_false]
        }
      end

      def fn_import_value(value)
        {
          'Fn::ImportValue' => value
        }
      end

      def fn_not(condition)
        {
          'Fn::Not' => [condition]
        }
      end

      def fn_or(*conditions)
        {
          'Fn::Or' => conditions
        }
      end

      def find_in_map(map_name, key_1, key_2)
        {
          'Fn::FindInMap' => [map_name, key_1, key_2]
        }
      end

      def get_att(resource, attr_name)
        {
          'Fn::GetAtt' => [resource, attr_name]
        }
      end

      def get_azs(region)
        {
          'Fn::GetAZs' => region
        }
      end

      def join(delimiter, *values)
        {
          'Fn::Join' => [delimiter, values]
        }
      end

      def select(index, *objects)
        {
          'Fn::Select' => [index, objects]
        }
      end

      def fn_ref(resource)
        {
          'Ref' => resource
        }
      end
    end
  end
end
