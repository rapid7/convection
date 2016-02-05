require_relative '../resource'
module Convection
  module Model
    class Template
      class Resource
        ##
        #  AWS::ElasticBeanstalk::Application
        ##
        class ElasticBeanstalkApplication < Resource
          type 'AWS::ElasticBeanstalk::Application', :elasticbeanstalk_application
          property :application_name, 'ApplicationName'
          property :description, 'Description'
        end
      end
    end
  end
end
