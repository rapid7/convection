require 'spec_helper'

class Convection::Model::Template::Resource
  describe EventsRule do
    let(:template) do
      Convection.template do
        description 'EventsRule Test Template'

        # TODO: Test simple properties of EventsRule as well?
        events_rule 'MyEventsRule' do
          event_pattern 'source', %w(aws.ec2)
          event_pattern 'detail', 'state' => %w(running)
          event_pattern 'detail-type', ['EC2 Instance State-change Notification']
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('MyEventsRule')
        .fetch('Properties')
    end

    it 'combines all event pattern calls into a single event pattern JSON object' do
      expect(subject['EventPattern']).to include(
        'source' => %w(aws.ec2),
        'detail' => { 'state' => %w(running) },
        'detail-type' => ['EC2 Instance State-change Notification']
      )
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
