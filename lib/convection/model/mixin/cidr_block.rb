require 'netaddr'

module Convection
  module Model
    module Mixin
      ##
      # Sanitized CIDR IP notation
      ##
      module CIDRBlock
        def cidr_property(name = :network, property_name = 'CidrBlock')
          property(name, property_name,
                   :transform => proc { |*args|
                     NetAddr::CIDR.create(*args)
                   })
        end
      end
    end
  end
end
