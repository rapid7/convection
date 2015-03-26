require_relative '../model/cloudfile'
require_relative '../model/event'

module Convection
  module Control
    ##
    # Control tour Clouds
    ##
    class Cloud
      def configure(cloudfile)
        @cloudfile = Model::Cloudfile.new(cloudfile)
      end

      def converge(&block)
        block.call(Model::Event.new('foobar', 'This is a test')) if block
      end
    end
  end
end
