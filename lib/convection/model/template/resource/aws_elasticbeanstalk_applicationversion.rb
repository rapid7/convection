require_relative '../resource'
module Convection
  module Model
    class Template
      class Resource
        ##
        #  AWS::ElasticBeanstalk::ApplicationVersion
        ##
        class ElasticBeanstalkApplicationVersion < Resource
          type 'AWS::ElasticBeanstalk::ApplicationVersion', :elasticbeanstalk_applicationversion
          property :application_name, 'ApplicationName'
          property :description, 'Description'
          property :source_bundle, 'SourceBundle'
        end
      end
    end
  end
end
