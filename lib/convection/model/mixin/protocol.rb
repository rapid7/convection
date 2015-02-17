require 'netaddr'

module Convection
  module Model
    module Mixin
      ##
      # ACL/SG protocol
      ##
      module Protocol
        def protocol(value)
          protocol_number =
            case value
            when :any then -1
            when :icmp then 1
            when :tcp then 6
            when :udp then 17
            else proto
            end

          property('Protocol', protocol_number)
        end
      end
    end
  end
end
