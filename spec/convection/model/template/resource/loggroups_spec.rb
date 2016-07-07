require 'spec_helper'

class Convection::Model::Template::Resource
  describe Lambda do
    let(:template) do
      Convection.template do
        description 'Logroups Test Template'

        resource 'testgroup' do
          type 'AWS::Logs::LogGroup'
          property 'RetentionInDays', 365
        end
      end
    end

    subject do
      template_json
    end

    it 'template is defined' do
      expect(subject).to_not eq(nil)
    end

    it 'resource values are properly set' do
      expect(subject['Resources'].include?('testgroup'))
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
