module Convection
  module Control
    # Monkey patch functions defined on Stack for use during terraform
    # export.
    class Stack
      alias _original_cloud cloud
      def cloud
        '${var.cloud}'
      end

      alias _original_region region
      def region
        '${data.aws_region.current.name}'
      end
    end
  end
end
