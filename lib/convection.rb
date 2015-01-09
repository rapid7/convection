##
# Root module
##
module Convection
  class << self
    def template(&block)
      Model::Template.new(&block)
    end

    def stack(name, template, options = {})
      Model::Stack.new(name, template, options)
    end
  end
end

require_relative 'convection/version'
require_relative 'convection/model'
