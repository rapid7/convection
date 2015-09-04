class ValidationError < StandardError
  attr_reader :object

  def initialize(object)
    @object = object
  end
end
