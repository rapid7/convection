# A YARD handler to deal with the "property" DSL method.
class PropertyDslHandler < YARD::Handlers::Ruby::Base
  handles method_call(:property)
  namespace_only # Do not process nested method calls.

  def process
    name = statement.parameters.first.jump(:tstring_content, :ident).source
    object = YARD::CodeObjects::MethodObject.new(namespace, name)
    object.parameters = [['value', nil]]
    register(object)

    cf_property = statement.parameters[1].source
    docstring = <<-DOC
@overload #{name}

  Returns the value of the #{cf_property} CloudFormation property.
@overload #{name}(value)

  Sets the #{cf_property} CloudFormation property.

  @param value the value to set the #{cf_property} CloudFormation property to.
DOC
    object.docstring = docstring if object.docstring.blank?(false)

    # modify the object
    object.dynamic = true
    object.scope = :instance
    object.name
  end
end
