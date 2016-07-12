require 'spec_helper'

class Convection::Model::Template::Resource
  describe IAMRole do
    let(:template) do
      Convection.template do
        description 'Trust Test Template'

        iam_role 'FooRole' do
          trust_service 'bar'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('FooRole')
        .fetch('Properties')
        .fetch('AssumeRolePolicyDocument')
    end

    it 'AssumeRolePolicyDocument is not nil' do
      expect(subject).to_not eq(nil)
    end

    it 'the policy statement documents principal is bar.amazonaws.com' do
      expect(subject['Statement'][0]['Principal']).to have_value('bar.amazonaws.com')
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
