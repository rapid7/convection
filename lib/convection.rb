##
# Root module
##
module Convection
  class << self
    # Global default option for whether to delay output when converging/diffing.
    #
    # @note This defines the default behaviour based on whether this value is set to 0 or false.
    #
    # @example
    #   $ export CONVECTION_DELAY_OUTPUT=true
    #   $ convection diff
    #   #> Delayed output when converging multiple clouds.
    # @example
    #   $ export CONVECTION_DELAY_OUTPUT=false
    #   $ convection diff
    #   #> Instant output
    # @example
    #   $ export CONVECTION_DELAY_OUTPUT=0
    #   $ convection diff
    #   #> Instant output
    def default_delay_output
      return nil unless ENV.key?('CONVECTION_DELAY_OUTPUT')
      return false if %w(0 false).include?(ENV['CONVECTION_DELAY_OUTPUT'])

      true
    end

    # Syntactic sugar for calling {Convection::Model::Template#initialize}.
    #
    # @see Convection::Model::Template#initialize
    def template(*args, &block)
      Model::Template.new(*args, &block)
    end

    # Syntactic sugar for calling {Convection::Control::Stack#initialize}.
    #
    # @see Convection::Control::Stack#initialize
    def stack(*args, &block)
      Control::Stack.new(*args, &block)
    end
  end
end

require_relative 'convection/version'
require_relative 'convection/model/attributes'
require_relative 'convection/model/template'
require_relative 'convection/control/stack'
