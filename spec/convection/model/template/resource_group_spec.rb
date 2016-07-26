require 'spec_helper'

class Convection::Model::Template
  describe ResourceGroup do
    let(:template) do
      Convection.template do
        description 'ResourceGroup Test Template'

        # A lone resource for testing merging of resources.
        ec2_instance 'FrontendServer'

        resource_group 'MyResourceGroup' do
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
      subject do
        Convection.template do
          description 'ResourceGroup Test Template'

          resource_group 'MyResourceGroup' do
            resource_group 'MyNestedGroup'
          end
        end
      end

      it 'raises a NotImplementedError when #execute is called' do
        expect { template.execute }.to raise_error(NotImplementedError)
      end
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
