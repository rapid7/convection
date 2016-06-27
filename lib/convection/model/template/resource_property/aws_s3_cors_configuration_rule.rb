require_relative '../resource_property'

module Convection
  module Model
    class Template
      class ResourceProperty
        # Represents an {http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-cors-corsrule.html
        # Amazon S3 Cors Configuration Rule}
        class S3CorsConfigurationRule < ResourceProperty
          property :allowed_headers, 'AllowedHeaders', :type => :list
          property :allowed_methods, 'AllowedMethods', :type => :list
          property :allowed_origins, 'AllowedOrigins', :type => :list
          property :exposed_headers, 'ExposedHeaders', :type => :list
          property :id, 'Id'
          property :max_age, 'MaxAge'
        end
      end
    end
  end
end
