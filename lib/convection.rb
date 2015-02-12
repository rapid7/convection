##
# Root module
##
module Convection
  class << self
    def template(&block)
      Model::Template.new(&block)
    end

    def stack(name, template, options = {})
      Control::Stack.new(name, template, options)
    end
  end
end

require_relative 'convection/version'
require_relative 'convection/model/template'
require_relative 'convection/control/stack'
