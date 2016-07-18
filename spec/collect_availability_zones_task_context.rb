RSpec.shared_context 'with a CollectAvailabilityZonesTask defined' do
  class CollectAvailabilityZonesTask
    attr_writer :availability_zones

    def availability_zones
      @availability_zones ||= []
    end

    def call(stack)
      self.availability_zones += stack.availability_zones
    end

    def success?
      availability_zones.any?
    end
  end
end
