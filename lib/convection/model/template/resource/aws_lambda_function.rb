require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Lambda::Function
        ##
        class Lambda < Resource
          type 'AWS::Lambda::Function'
          property :code, 'Code'
          property :description, 'Description'
          property :handler, 'Handler'
          property :memory_size, 'MemorySize'
          property :runtime, 'Runtime', :equal_to => ['nodejs', 'java8', 'python2.7']
          property :timeout, 'Timeout'
        end
      end
    end
  end
end
