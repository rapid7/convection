require 'spec_helper'

class Convection::Model::Template
  describe '#validate_resources' do
    context 'with regular Resource name' do
      subject do
        Convection.template do
          description 'Validations Test Template - Regular Resource Name'

          resource 'Resource0'
        end
      end

      it 'raises an excessive resource name error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to_not raise_error
      end
    end

    context 'with excessive Resource name' do
      subject do
        Convection.template do
          description 'Validations Test Template - Excessive Resource Name'

          resource '0' * (CF_MAX_RESOURCE_NAME + 1)
        end
      end

      it 'raises an excessive resource name error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveResourceNameError)
      end
    end

    context 'with excessive Resources' do
      subject do
        Convection.template do
          description 'Validations Test Template - Too Many Resources'

          (CF_MAX_RESOURCES + 1).times { |i| resource "TestResource#{i}" }
        end
      end

      it 'raises an excessive resources error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveResourcesError)
      end
    end
  end
end
