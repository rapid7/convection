require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        #  AWS::ElasticBeanstalk::ConfigurationTemplate
        ##
        class ElasticBeanstalkConfigurationTemplate < Resource
          type 'AWS::ElasticBeanstalk::ConfigurationTemplate', :elasticbeanstalk_configurationtemplate
          property :application_name, 'ApplicationName'
          property :description, 'Description'
          property :environment, 'Environment'
          property :option_settings, 'OptionSettings'
          property :solution_stack_name, 'SolutionStackName'
          property :source_configuration, 'SourceConfiguration'
        end
      end
    end
  end
end
    
