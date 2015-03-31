class FogAttributeHandler < YARD::Handlers::Ruby::Base
  handles method_call(:attribute)
  handles method_call(:identity)

  def process
    name = statement.parameters.first.jump(:tstring_content, :ident).source
    object = YARD::CodeObjects::MethodObject.new(namespace, name)
    register(object)

    # modify the object
    object.dynamic = true
  end
end
