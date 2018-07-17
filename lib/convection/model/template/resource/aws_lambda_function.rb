require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::Lambda::Function
        ##
        class Lambda < Resource
          include Model::Mixin::Taggable

          type 'AWS::Lambda::Function'
          property :function_name, 'FunctionName'
          property :description, 'Description'
          property :handler, 'Handler'
          property :memory_size, 'MemorySize'
          property :runtime, 'Runtime'
          property :timeout, 'Timeout'
          property :role, 'Role'
          property :kms_key_arn, 'KmsKeyArn'
          property :concurrency, 'ReservedConcurrentExecutions'
          # psuedo-property definitions. We add the expected name as a nested DSL for these below.
          property :env, 'Environment'
          property :function_code, 'Code'
          property :vpc_cfg, 'VpcConfig'
          property :dead_letter_cfg, 'DeadLetterConfig'

          # Add code block
          def code(&block)
            function_code = ResourceProperty::LambdaFunctionCode.new(self)
            function_code.instance_exec(&block) if block
            properties['Code'].set(function_code)
          end

          def environment(&block)
            env = ResourceProperty::LambdaEnvironment.new(self)
            env.instance_exec(&block) if block
            properties['Environment'].set(env)
          end

          # Add vpc_config block
          def vpc_config(&block)
            vpc_cfg = ResourceProperty::LambdaVpcConfig.new(self)
            vpc_cfg.instance_exec(&block) if block
            properties['VpcConfig'].set(vpc_cfg)
          end

          def dead_letter_config(&block)
            dead_letter_cfg = ResourceProperty::LambdaFunctionDeadLetterConfig.new(self)
            dead_letter_cfg.instance_exec(&block) if block
            properties['DeadLetterConfig'].set(dead_letter_cfg)
          end
        end
      end
    end
  end
end
