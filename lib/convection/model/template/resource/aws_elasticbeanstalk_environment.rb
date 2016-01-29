require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        #  AWS::ElasticBeanstalk::Environment
        ##
        class ElasticBeanstalkEnvironment < Resource
          type 'AWS::ElasticBeanstalk::Environment', :elasticbeanstalk_environment
          property :application_name, 'ApplicationName'
          property :cname_prefix, 'CNAMEPrefix'
          property :description, 'Description'
          property :environment_name, 'EnvironmentName'
          property :option_settings, 'OptionSettings'
          property :solution_stack_name, 'SolutionStackName'
          property :tags, 'Tags'
          property :template_name, 'TemplateName'
          property :tier, 'Tier'
          property :version_label, 'VersionLabel'
        end
      end
    end
  end
end
    
