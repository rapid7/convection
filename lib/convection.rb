##
# Root module
##
module Convection
  class << self
    def template(&block)
      Model::Template.new(&block)
    end

    def stack(name, region = nil, credentials = nil)
      Model::Stack.new(name, region, credentials)
    end
  end
end

require_relative "convection/version"
require_relative 'convection/model'
