require 'spec_helper'

class Convection::Model::Template
  describe '#validate_parameters' do
    context 'with regular Parameter count/name' do
      subject do
        Convection.template do
          description 'Validations Test Template - Regular Parameter Name'

          parameter 'Parameter0' do
            type 'String'
            description 'Example Parameter'
            default 'm3.medium'
          end
        end
      end

      it 'does not raise an parameter count/name error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to_not raise_error
      end
    end

    context 'with excessive Parameter Bytesize' do
      subject do
        Convection.template do
          description 'Validations Test Template - Excessive Parameter Bytesize'

          parameter 'Parameter0' do
            type 'String'
            description 'Example Parameter'
            default '0' * (CF_MAX_PARAMETER_VALUE_BYTESIZE + 1)
          end
        end
      end

      it 'raises an excessive parameter bytesize error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveParameterBytesizeError)
      end
    end

    context 'with excessive Parameter Name' do
      subject do
        Convection.template do
          description 'Validations Test Template - Excessive Parameter Name'

          parameter_name = '0' * (CF_MAX_PARAMETER_NAME_CHARACTERS + 1)
          parameter parameter_name do
            type 'String'
            description 'Example Parameter'
            default 'm3.medium'
          end
        end
      end

      it 'raises an excessive parameter name error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveParameterNameError)
      end
    end

    context 'with excessive Parameters' do
      subject do
        Convection.template do
          description 'Validations Test Template - Too Many Parameters'

          (CF_MAX_PARAMETERS + 1).times do |i|
            parameter "Parameter#{i}" do
              type 'String'
              description 'Example Parameter'
              default 'm3.medium'
            end
          end
        end
      end

      it 'raises an excessive parameters error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveParametersError)
      end
    end
  end
end
