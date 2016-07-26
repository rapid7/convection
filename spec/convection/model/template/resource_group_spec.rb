require 'spec_helper'

class Convection::Model::Template
  describe ResourceGroup do
    let(:template) do
      Convection.template do
        description 'UpdatePolicies Test Template'

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

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
