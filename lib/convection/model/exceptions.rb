ValidationError = Class.new( StandardError )

ExcessiveResourcesError = Class.new( ValidationError)
ExcessiveResourceNameError = Class.new( ValidationError)
ExcessiveMappingsError = Class.new( ValidationError)
ExcessiveMappingAttributesError = Class.new( ValidationError)
ExcessiveMappingNameError = Class.new( ValidationError)
ExcessiveMappingAttributeNameError = Class.new( ValidationError)
ExcessiveParametersError = Class.new( ValidationError)
ExcessiveParameterNameError = Class.new( ValidationError)
ExcessiveParameterBytesizeError = Class.new( ValidationError)
ExcessiveOutputsError = Class.new( ValidationError)
ExcessiveOutputNameError = Class.new( ValidationError)
ExcessiveDescriptionError = Class.new( ValidationError)
ExcessiveTemplateSizeError = Class.new( ValidationError)

def limit_exceeded_error(value, limit, error_class)
  raise error_class, "Value #{value} exceeds Limit #{limit}"
end
