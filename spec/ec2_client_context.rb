RSpec.shared_context 'with a mock EC2 client' do
  let(:ec2_availability_zone_description) do
    zones = %w(eu-central-1 eu-west-1).map do |name|
      double("availability zone (#{name})", zone_name: name)
    end

    double(:availability_zone_description, availability_zones: zones)
  end

  let(:ec2_client) do
    client = double(:ec2_client, describe_availability_zones: ec2_availability_zone_description)
    client.stub(:describe_stacks) do
      fail Aws::CloudFormation::Errors::ValidationError.new(context, 'Stack does not exist.')
    end

    client
  end
end
