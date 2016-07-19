require 'pp'

class MyModuleHandler < YARD::Handlers::Ruby::Base
  handles method_call(:property)



  def process
    name = statement.parameters.first.jump(:tstring_content, :ident).source
    object = YARD::CodeObjects::MethodObject.new(namespace, name)
    register(object)

    # modify the object
    object.dynamic = true
    object.scope = :class
    object.name

  end
end