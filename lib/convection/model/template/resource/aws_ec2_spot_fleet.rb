require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::SpotFleet
        ##
        class SpotFleet < Resource

          type 'AWS::EC2::SpotFleet'
          property :spot_fleet_request_configuration, 'SpotFleetRequestConfigData'

          # Configuration for a Spot fleet request
          def spot_fleet_request_configuration(&block)
            config = ResourceProperty::EC2SpotFleetRequestConfigData.new(self)
            config.instance_exec(&block) if block
            properties['SpotFleetRequestConfigData'].set(config)
          end
        end
      end
    end
  end
end
