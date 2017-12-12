module Convection
  module Control
    class Stack
      alias_method :_original_cloud, :cloud
      def cloud
        '${var.cloud}'
      end

      alias_method :_original_region, :region
      def region
        '${data.aws_region.current.name}'
      end
    end
  end
end
