require 'spec_helper'
require 'pp'
class Convection::Model::Template::Resource
  describe Lambda do
    let(:template) do
      Convection.template do
        description 'Lambda Permission Test Template'

        lambda_permission 'LambdaInvokePermission' do
          action 'lambda:InvokeFunction'
          function_name get_att('MyLambdaFunction', 'Arn')
          principal 's3.amazonaws.com'
          source_account fn_ref('AWS::AccountId')
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('LambdaInvokePermission')
        .fetch('Properties')
    end

    it 'action parameter is set correctly' do
      expect(subject['Action']).to eq('lambda:InvokeFunction')
    end

    it 'function name parameter is set with get_att' do
      expect(subject['FunctionName']).to eq('Fn::GetAtt' => %w(MyLambdaFunction Arn))
    end

    it 'source account fn ref sets param properly' do
      expect(subject['SourceAccount']).to eq('Ref' => 'AWS::AccountId')
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
