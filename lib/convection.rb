##
# Root module
##
module Convection
  class << self
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
