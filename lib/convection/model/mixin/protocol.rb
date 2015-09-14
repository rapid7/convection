require 'netaddr'

module Convection
  module Model
    module Mixin
      ##
      # Map IP protocol names to numbers
      ##
      module Protocol
        class << self
          def lookup(value)
            case value
            when :any then -1
            when :icmp then 1
            when :tcp then 6
            when :udp then 17
            else value
            end
          end
        end

        def protocol_property(name = :protocol, property_name = 'IpProtocol')
          property(name, property_name,
                   :transform => Mixin::Protocol.method(:lookup))
        end
      end
    end
  end
end
