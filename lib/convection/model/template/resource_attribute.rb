module Convection
  module Model
    class Template
      # Base class for {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-product-attribute-reference.html}
      class ResourceAttribute
        def initialize(parent)
          parent.resource_attributes << self
        end
      end
    end
  end
end

## Require all resource attributes
Dir.glob(File.expand_path('../resource_attribute/*.rb', __FILE__)).map { |r| require r }
