require 'netaddr'

module Convection
  module Model
    module Mixin
      ##
      # Add condition helpers
      ##
      module CIDRBlock
        def network(address = nil)
          @network = NetAddr::CIDR.create(address) unless address.nil?
          property('CidrBlock', @network.to_s)
        end
      end
    end
  end
end
