class ExcessiveResourcesError < StandardError; end
class ExcessiveResourceNameError < StandardError; end
class ExcessiveMappingsError < StandardError; end
class ExcessiveMappingAttributesError < StandardError; end
class ExcessiveMappingNameError < StandardError; end
class ExcessiveMappingAttributeNameError < StandardError; end
class ExcessiveParametersError < StandardError; end
class ExcessiveParameterNameError < StandardError; end
class ExcessiveParameterBytesizeError < StandardError; end
class ExcessiveOutputsError < StandardError; end
class ExcessiveOutputNameError < StandardError; end
class ExcessiveDescriptionError < StandardError; end
class ExcessiveTemplateSizeError < StandardError; end

def raiseIt(errorClass)
  raise errorClass, 'Validation Error'
end
