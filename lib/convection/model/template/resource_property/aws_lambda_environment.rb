require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/lambda/latest/dg/API_Environment.html}
        class LambdaEnvironment < ResourceProperty
          property :variables, 'Variables'
        end
      end
    end
  end
end
