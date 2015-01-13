require 'netaddr'

module Convection
  module Model
    module Mixin
      ##
      # Add condition helpers
      ##
      module CIDRBlock
        def network(*args)
          @network = NetAddr::CIDR.create(*args) unless args.empty?
          property('CidrBlock', @network.to_s)
        end
      end
    end
  end
end
