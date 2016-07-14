require 'spec_helper'

class Convection::Model::Template
  describe '#validate_mappings' do
    context 'with a regular Mappings' do
      subject do
        Convection.template do
          mapping 'Mapping0' do
            item 'us-east-1', 'test', 'cf-test-keys'
          end
        end
      end

      it 'does not raise an excessive mappings error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to_not raise_error
      end
    end

    context 'with excessive Mappings' do
      subject do
        Convection.template do
          (CF_MAX_MAPPINGS + 1).times do |i|
            mapping "Mapping#{i}" do
              item 'us-east-1', 'test', 'cf-test-keys'
              item 'us-west-1', 'test', 'cf-test-keys'
            end
          end
        end
      end

      it 'raises an excessive mappings error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveMappingsError)
      end
    end

    context 'with excessive Mappings Name' do
      subject do
        Convection.template do
          mapping_name = '0' * (CF_MAX_MAPPING_NAME + 1)
          mapping mapping_name do
            item 'us-east-1', 'test', 'cf-test-keys'
            item 'us-west-1', 'test', 'cf-test-keys'
          end
        end
      end

      it 'raises an excessive mappings error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveMappingNameError)
      end
    end

    context 'with excessive Mappings Attributes' do
      subject do
        Convection.template do
          mapping 'Mapping0' do
            (CF_MAX_MAPPING_ATTRIBUTES + 1).times do |i|
              item "#{i}1", "#{i}2", "#{i}3"
            end
          end
        end
      end

      it 'raises an excessive mapping attributes error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveMappingAttributesError)
      end
    end

    context 'with excessive Mappings Attribute names' do
      subject do
        Convection.template do
          mapping 'Mapping0' do
            attribute_name = '0' * (CF_MAX_MAPPING_ATTRIBUTE_NAME + 1)
            item attribute_name, 'value', 'value'
          end
        end
      end

      it 'raises an excessive mapping attribute names error' do
        rendered = subject.render
        expect { subject.validate(rendered) }.to raise_error(ExcessiveMappingAttributeNameError)
      end
    end
  end
end
