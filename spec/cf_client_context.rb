RSpec.shared_context 'with a mock CloudFormation client' do
  let(:cf_client) do
    client = double(:cf_client, create_stack: nil, delete_stack: nil, update_stack: nil)
    allow(client).to receive(:describe_stacks) {
      fail Aws::CloudFormation::Errors::ValidationError.new(nil, 'Stack does not exist.')
    }

    client
  end
end
