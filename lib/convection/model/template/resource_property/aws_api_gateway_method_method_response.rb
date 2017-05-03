require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-apitgateway-method-methodresponse.html
        # API Gateway Method MethodResponse Property Type}
        class ApiGatewayMethodMethodResponse < ResourceProperty
          property :response_models, 'ResponseModels', :type => :hash # { String:String, ... },
          property :response_parameters, 'ResponseParameters', :type => :hash # { String:Boolean, ... },
          property :status_code, 'StatusCode'
        end
      end
    end
  end
end
