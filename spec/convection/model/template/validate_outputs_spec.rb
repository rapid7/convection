require 'spec_helper'

class Convection::Model::Template
  describe '#validate_outputs' do
    context 'with regular Output count/name' do
      subject do
        Convection.template do
          description 'Validations Test Template - Regular Output Name'

          output 'TestOutput' do
            description 'An Important Attribute'
            value get_att('Resource', 'Attribute')
          end
        end
      end

      it 'does not raise an output count/name error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to_not raise_error
      end
    end

    context 'with excessive Output Name' do
      subject do
        Convection.template do
          description 'Validations Test Template - Excessive Output Name'

          output_name = '0' * (CF_MAX_OUTPUT_NAME_CHARACTERS + 1)
          output output_name do
            description 'An Important Attribute'
            value get_att('Resource', 'Attribute')
          end
        end
      end

      it 'raises an excessive output name error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveOutputNameError)
      end
    end

    context 'with excessive Outputs' do
      subject do
        Convection.template do
          description 'Validations Test Template - Too Many Outputs'

          (CF_MAX_OUTPUTS + 1).times do |i|
            output "TestOutput#{i}" do
              description 'An Important Attribute'
              value get_att('Resource', 'Attribute')
            end
          end
        end
      end

      it 'raises an excessive outputs error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveOutputsError)
      end
    end
  end
end
