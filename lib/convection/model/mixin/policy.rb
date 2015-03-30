module Convection
  module Model
    module Mixin
      ##
      # Add definition helpers for entities with policies
      ##
      module Policy
        class << self
          def included(mod)
            mod.extend(ClassHelpers)
          end
        end

        module ClassHelpers
          def policy(accesor, property_name, options = {}, &block)
            define_method(accesor) do |policy_name|
              document = Document.new(policy_name, @template)
              document.instance_exec(&block) if block

              return @properties[property_name] = document unless options[:collection]
              @properties[property_name] =  [] unless @properties[property_name].is_a?(Array)
              @properties[property_name] << document
            end
          end
        end

        ##
        # An IAM policy document
        ##
        class Document < Resource
          DEFAULT_VERSION = '2012-10-17'

          attribute :name
          attribute :version
          list :statement

          def initialize(name, template)
            super

            @version = DEFAULT_VERSION
            @statement = []
          end

          def render
            {
              'PolicyName' => name,
              'PolicyDocument' => {
                'Version' => version,
                'Statement' => statement
              }
            }
          end
        end

        ##
        # An IAM policy statement
        ##
        class Statement < Resource
          attribute :effect
          list :action
          list :resource

          def initialize(name, template)
            super
            @effect = 'Allow'
            @action = []
            @resource = []
          end

          def render
            {
              'Effect' => effect,
              'Action' => action,
              'Resource' => resource
            }
          end
        end
      end
    end
  end
end
