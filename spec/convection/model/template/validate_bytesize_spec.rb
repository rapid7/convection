require 'spec_helper'

class Convection::Model::Template
  describe '#validate_bytesize' do
    context 'with a regular Template bytesize' do
      subject do
        Convection.template do
          description 'Validations Test Template - Regular Bytesize'
        end
      end

      it 'does not raise an excessive description error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to_not raise_error
      end
    end

    context 'with excessive Template bytesize' do
      subject do
        Convection.template do
          description 'Validations Test Template - Excessive Bytesize'

          200.times do |count|
            ec2_instance "EC2_INSTANCE_#{count}" do
              availability_zone 'us-east-1a'
              property 'ImageId', 'ami-76e27e1e'
              property 'KeyName', 'test'
              security_group 'sg-dd733c41'
              security_group 'sg-dd738df3'
              tag 'Name', 'test-1'
            end
          end

          80.times do |count|
            mapping "Mapping_#{count}" do
              item 'us-east-1', 'test', 'cf-test-keys'
              item 'us-west-1', 'test', 'cf-test-keys'
            end
          end
        end
      end

      it 'raises an excessive description error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveTemplateSizeError)
      end
    end
  end
end
