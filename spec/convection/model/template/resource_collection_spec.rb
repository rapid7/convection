require 'spec_helper'

class Convection::Model::Template
  describe ResourceCollection do

    class WebService < Convection::Model::Template::ResourceCollection
      attach_to_dsl(:web_service)

      attribute :use_elastic_load_balancing

      def execute
        web_service = self # Expose this instance to nested template methods.

        ec2_instance "#{name}WebService"

        elb "#{name}LoadBalancer" do
          tag 'Description', "Load balancer for the #{web_service.name} web service."
        end if use_elastic_load_balancing
      end
    end

    let(:use_elb_value) { nil }
    let(:template) do
      outer_scope = self
      Convection.template do
        description 'ResourceCollection Test Template'

        # A lone resource for testing merging of resources and nested resources.
        ec2_instance 'LoneResource1'

        web_service 'ExampleDotOrg' do
          use_elastic_load_balancing outer_scope.use_elb_value
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
    end

    context 'when the use_elastic_load_balancing attribute is set' do
      let(:use_elb_value) { true }

      it { is_expected.to have_key('LoneResource1') }
      it { is_expected.to have_key('ExampleDotOrgWebService') }
      it { is_expected.to have_key('ExampleDotOrgLoadBalancer') }
    end

    context 'when the use_elastic_load_balancing attribute is not set' do
      let(:use_elb_value) { false }

      it { is_expected.to have_key('LoneResource1') }
      it { is_expected.to have_key('ExampleDotOrgWebService') }
      it { is_expected.to_not have_key('ExampleDotOrgLoadBalancer') }
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
