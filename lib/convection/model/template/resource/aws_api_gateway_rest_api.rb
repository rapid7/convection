require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ApiGateway::RestApi
        ##
        class ApiGatewayRestApi < Resource
          type 'AWS::ApiGateway::RestApi'
          property :body, 'Body' # JSON object
          property :body_s3_location_prop, 'BodyS3Location' # S3Location
          property :clone_from, 'CloneFrom'
          property :description, 'Description'
          property :fail_on_warnings, 'FailOnWarnings'
          property :name, 'Name'
          property :parameters, 'Parameters', :type => :list # [ String, ... ]

          def body_s3_location(&block)
            b = ResourceProperty::ApiGatewayRestApiS3Location.new(self)
            b.instance_exec(&block) if block
            properties['BodyS3Location'].set(b)
          end
        end
      end
    end
  end
end
