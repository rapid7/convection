require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-events-rule-target.html
        # CloudWatch Events Rule Target}
        class EventsRuleTarget < ResourceProperty
          property :arn, 'Arn'
          property :id, 'Id'
          property :input, 'Input'
          property :input_path, 'InputPath'
        end
      end
    end
  end
end
