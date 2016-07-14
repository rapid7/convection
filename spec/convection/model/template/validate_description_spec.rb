require 'spec_helper'

class Convection::Model::Template
  describe '#validate_description' do
    context 'with a regular Description bytesize' do
      subject do
        Convection.template do
          description '0' * CF_MAX_DESCRIPTION_BYTESIZE
        end
      end

      it 'does not raise an excessive description error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to_not raise_error
      end
    end

    context 'with excessive Description bytesize' do
      subject do
        Convection.template do
          description '0' * (CF_MAX_DESCRIPTION_BYTESIZE + 1)
        end
      end

      it 'raises an excessive description error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveDescriptionError)
      end
    end
  end
end
