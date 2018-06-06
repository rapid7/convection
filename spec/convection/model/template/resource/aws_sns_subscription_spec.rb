require 'spec_helper'

class Convection::Model::Template::Resource
  describe SNSSubscription do
    let(:template) do
      Convection.template do
        sns_subscription 'MySubscription' do
          endpoint 'failures@example.com'
          protocol 'email'
          topic_arn 'arn:aws:sns:us-west-2:123456789012:example-topic'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('MySubscription')
        .fetch('Properties')
    end

    it 'sets the Endpoint' do
      expect(subject['Endpoint']).to eq('failures@example.com')
    end

    it 'sets the Protocol' do
      expect(subject['Protocol']).to eq('email')
    end

    it 'sets the TopicArn' do
      expect(subject['TopicArn']).to eq('arn:aws:sns:us-west-2:123456789012:example-topic')
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
