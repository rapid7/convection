##
# Root module
##
module Convection
  class << self
    attr_writer :default_credential_error_max_retries
    attr_writer :default_credential_error_wait_time_seconds

    # Defines a global default used when initialising AWS SDK clients
    # internal to convection.
    def default_credential_error_max_retries
      @default_credential_error_max_retries ||= 10
    end

    # Defines a global default used when initialising AWS SDK clients
    # internal to convection.
    def default_credential_error_wait_time_seconds
      @default_credential_error_wait_time_seconds ||= 5
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
