ExcessiveResourcesError = Class.new( StandardError)
ExcessiveResourceNameError = Class.new( StandardError)
ExcessiveMappingsError = Class.new( StandardError)
ExcessiveMappingAttributesError = Class.new( StandardError)
ExcessiveMappingNameError = Class.new( StandardError)
ExcessiveMappingAttributeNameError = Class.new( StandardError)
ExcessiveParametersError = Class.new( StandardError)
ExcessiveParameterNameError = Class.new( StandardError)
ExcessiveParameterBytesizeError = Class.new( StandardError)
ExcessiveOutputsError = Class.new( StandardError)
ExcessiveOutputNameError = Class.new( StandardError)
ExcessiveDescriptionError = Class.new( StandardError)
ExcessiveTemplateSizeError = Class.new( StandardError)

def LimitExceededError(value, limit, errorClass)
  raise errorClass, "Value #{value} exceeds Limit #{limit}"
end
