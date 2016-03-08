require_relative '../resource'

module Convection
  module DSL
    module Template
      module Resource
        ## Role DSL
        module KmsKey
          def policy(&block)
            add_policy = Model::Mixin::Policy.new(:name => 'kms_policy', :template => @template)
            add_policy.instance_exec(&block) if block
            self.key_policy = add_policy.document
          end
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::KMS::Key
        ##
        class KmsKey < Resource
          include DSL::Template::Resource::KmsKey

          type 'AWS::KMS::Key'
          property :description, 'Description'
          property :enabled, 'Enabled'
          property :enabled_key_rotation, 'EnabledKeyRotation'
          alias key_rotation enabled_key_rotation
          property :key_policy, 'KeyPolicy'
        end
      end
    end
  end
end
