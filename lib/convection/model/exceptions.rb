class ValidationError < StandardError; end
class ExcessiveResourcesError < ValidationError; end
class ExcessiveResourceNameError < ValidationError; end
class ExcessiveMappingsError < ValidationError; end
class ExcessiveMappingAttributesError < ValidationError; end
class ExcessiveMappingNameError < ValidationError; end
class ExcessiveMappingAttributeNameError < ValidationError; end
class ExcessiveParametersError < ValidationError; end
class ExcessiveParameterNameError < ValidationError; end
class ExcessiveParameterBytesizeError < ValidationError; end
class ExcessiveOutputsError < ValidationError; end
class ExcessiveOutputNameError < ValidationError; end
class ExcessiveDescriptionError < ValidationError; end
class ExcessiveTemplateSizeError < ValidationError; end

def limit_exceeded_error(value, limit, error_class)
  fail error_class, "Value #{value} exceeds Limit #{limit}"
end
