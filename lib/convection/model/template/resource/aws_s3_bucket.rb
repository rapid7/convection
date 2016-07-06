require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::S3::Bucket
        ##
        class S3Bucket < Resource
          include Model::Mixin::Taggable

          type 'AWS::S3::Bucket'
          property :bucket_name, 'BucketName'
          property :access_control, 'AccessControl'
          property :cors_configuration, 'CorsConfiguration'
          property :lifecycle_configuration, 'LifecycleConfiguration'
          property :logging_configuration, 'LoggingConfiguration'
          property :notification_configuration, 'NotificationConfiguration'
          property :versioning_configuration, 'VersioningConfiguration'

          def cors_configuration(opts = {}, &block)
            config = ResourceProperty::S3CorsConfiguration.new(self)

            # TODO: Remove this deprecation and remove the opts declaration/usage hash above/below.
            warn 'DEPRECATED: Defining cors_configuration with an options Hash is deprecated. Please use a configuration block instead. https://github.com/rapid7/convection/pull/143' if opts && opts.any?
            ResourceProperty::S3CorsConfiguration.properties.each do |_name, property|
              property_name = property.property_name
              config.properties[property_name] = opts[property_name] if opts.key?(property_name)
            end

            config.instance_exec(&block) if block
            properties['CorsConfiguration'].set(config)
          end

          def cors_configurationm(*args)
            warn 'DEPRECATED: "cors_configurationm" is deprecated. Please use "cors_configuration" instead. https://github.com/rapid7/convection/pull/135'
            cors_configuration(*args)
          end

          def lifecycle_configuration(opts = {}, &block)
            config = ResourceProperty::S3LifecycleConfiguration.new(self)

            # TODO: Remove this deprecation and remove the opts declaration/usage hash above/below.
            warn 'DEPRECATED: Defining lifecycle_configuration with an options Hash is deprecated. Please use a configuration block instead. https://github.com/rapid7/convection/pull/143' if opts && opts.any?
            ResourceProperty::S3LifecycleConfiguration.properties.each do |_name, property|
              property_name = property.property_name
              config.properties[property_name] = opts[property_name] if opts.key?(property_name)
            end

            config.instance_exec(&block) if block
            properties['LifecycleConfiguration'].set(config)
          end

          def logging_configuration(opts = {}, &block)
            config = ResourceProperty::S3LoggingConfiguration.new(self)

            # TODO: Remove this deprecation and remove the opts declaration/usage hash above/below.
            warn 'DEPRECATED: Defining logging_configuration with an options Hash is deprecated. Please use a configuration block instead. https://github.com/rapid7/convection/pull/143' if opts && opts.any?
            ResourceProperty::S3LoggingConfiguration.properties.each do |_name, property|
              property_name = property.property_name
              config.properties[property_name] = opts[property_name] if opts.key?(property_name)
            end

            config.instance_exec(&block) if block
            properties['LoggingConfiguration'].set(config)
          end

          def notification_configuration(opts = {}, &block)
            config = ResourceProperty::S3NotificationConfiguration.new(self)

            # TODO: Remove this deprecation and remove the opts declaration/usage hash above/below.
            warn 'DEPRECATED: Defining notification_configuration with an options Hash is deprecated. Please use a configuration block instead. https://github.com/rapid7/convection/pull/143' if opts && opts.any?
            ResourceProperty::S3NotificationConfiguration.properties.each do |_name, property|
              property_name = property.property_name
              config.properties[property_name] = opts[property_name] if opts.key?(property_name)
            end

            config.instance_exec(&block) if block
            properties['NotificationConfiguration'].set(config)
          end

          def replication_configuration(opts = {}, &block)
            config = ResourceProperty::S3ReplicationConfiguration.new(self)

            # TODO: Remove this deprecation and remove the opts declaration/usage hash above/below.
            warn 'DEPRECATED: Defining replication_configuration with an options Hash is deprecated. Please use a configuration block instead. https://github.com/rapid7/convection/pull/143' if opts && opts.any?
            ResourceProperty::S3ReplicationConfiguration.properties.each do |_name, property|
              property_name = property.property_name
              config.properties[property_name] = opts[property_name] if opts.key?(property_name)
            end

            config.instance_exec(&block) if block
            properties['ReplicationConfiguration'].set(config)
          end

          def versioning_configuration(opts = {}, &block)
            config = ResourceProperty::S3VersioningConfiguration.new(self)

            # TODO: Remove this deprecation and remove the opts declaration/usage hash above/below.
            warn 'DEPRECATED: Defining versioning_configuration with an options Hash is deprecated. Please use a configuration block instead. https://github.com/rapid7/convection/pull/143' if opts && opts.any?
            ResourceProperty::S3VersioningConfiguration.properties.each do |_name, property|
              property_name = property.property_name
              config.properties[property_name] = opts[property_name] if opts.key?(property_name)
            end

            config.instance_exec(&block) if block
            properties['VersioningConfiguration'].set(config)
          end

          def website_configuration(opts = {}, &block)
            config = ResourceProperty::S3WebsiteConfiguration.new(self)

            # TODO: Remove this deprecation and remove the opts declaration/usage hash above/below.
            warn 'DEPRECATED: Defining website_configuration with an options Hash is deprecated. Please use a configuration block instead. https://github.com/rapid7/convection/pull/143' if opts && opts.any?
            ResourceProperty::S3WebsiteConfiguration.properties.each do |_name, property|
              property_name = property.property_name
              config.properties[property_name] = opts[property_name] if opts.key?(property_name)
            end

            config.instance_exec(&block) if block
            properties['WebsiteConfiguration'].set(config)
          end

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
