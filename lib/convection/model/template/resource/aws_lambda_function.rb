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
          property :function_code, 'Code'
          property :function_name, 'FunctionName'
          property :description, 'Description'
          property :handler, 'Handler'
          property :memory_size, 'MemorySize'
          property :runtime, 'Runtime'
          property :timeout, 'Timeout'
          property :role, 'Role'
          property :vpc_cfg, 'VpcConfig'

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
        end
      end
    end
  end
end
