require 'spec_helper'

class Convection::Model::Template
  describe ResourceCollection do
    let(:template) do
      Convection.template do
        description 'ResourceCollection Test Template'

        # A lone resource for testing merging of resources.
        ec2_instance 'FrontendServer'

        resource_collection 'MyResourceCollection' do
          ec2_instance 'BackendServer'
          rds_instance 'PrimaryDb'
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
    end

    it { is_expected.to have_key('FrontendServer') }
    it { is_expected.to have_key('BackendServer') }
    it { is_expected.to have_key('PrimaryDb') }

    context 'when attempting to define a nested resource group' do
      subject(:template) do
        Convection.template do
          description 'ResourceCollection Test Template'

          resource_collection 'MyResourceCollection' do
            resource_collection 'MyNestedGroup'
          end
        end
      end

      it 'raises a NotImplementedError when Template#execute is called' do
        expect { subject.execute }.to raise_error(NotImplementedError)
      end
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
