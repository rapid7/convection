module Convection
  module Model
    module Mixin
      module Colorize
        def colorize(param, options = {})
          define_method(:color) do
            case instance_variable_get("@#{ param }")
            when *options.fetch(:white, [:status]) then :white
            when *options.fetch(:cyan, [:debug, :trace]) then :cyan
            when *options.fetch(:green, [:info, :success, :create]) then :green
            when *options.fetch(:yellow, [:warn, :update]) then :yellow
            when *options.fetch(:red, [:error, :fail, :delete, :replace]) then :red
            else options.fetch(:default, :green)
            end
          end
        end
      end
    end
  end
end
