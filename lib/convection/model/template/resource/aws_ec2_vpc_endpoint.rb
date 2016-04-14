require 'forwardable'
require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::VpcEndpoint
        ##
        class EC2VPCEndpoint < Resource
          extend Forwardable

          type 'AWS::EC2::VPCEndpoint'
          property :vpc, 'VpcId'
          property :route_tables, 'RouteTableIds', :type => :list
          property :service_name, 'ServiceName'
          attr_reader :document # , 'PolicyDocument'

          def_delegators :@document, :allow, :deny, :id, :version, :statement
          def_delegator :@document, :name, :policy_name

          def initialize(*args)
            super
            @document = Model::Mixin::Policy.new(:name => false, :template => @template)
          end

          def service(val)
            properties['ServiceName'].set(join('', 'com.amazonaws.', fn_ref('AWS::Region'), val))
          end

          def render
            super.tap do |r|
              document.render(r['Properties'])
            end
          end
        end
      end
    end
  end
end
