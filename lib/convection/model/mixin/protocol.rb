require 'netaddr'

module Convection
  module Model
    module Mixin
      ##
      # Map IP protocol names to numbers
      ##
      module Protocol
        def protocol_property(name = :protocol)
          attr_reader name

          writer = proc do |value = nil|
            instance_variable_set("@#{ name }", case value
                                                when :any then -1
                                                when :icmp then 1
                                                when :tcp then 6
                                                when :udp then 17
                                                else value
            end) unless value.nil?
            instance_variable_get("@#{ name }")
          end

          define_method(name, &writer)
          define_method("#{name}=", &writer)
        end
      end
    end
  end
end
