require 'spec_helper'

class Convection::Model::Template::Resource
  describe DirectoryServiceSimpleAD do
    let(:simple_ad_template) do
      Convection.template do
        directoryservice_simple_ad 'SimpleActiveDirectory' do
          description 'Example simple AD'
          enable_sso false
          name 'ExampleSimpleAD'
          password 'directory.password'
          short_name 'directory.name'
          size 'Small'

          vpc_settings 'SubnetIds', ['subnet-deadb33f']
          vpc_settings 'VpcId', 'vpc-deadb33f'
        end
      end
    end

    it 'sets VpcSettings.SubnetIds' do
      vpc_settings = simple_ad_json.fetch('Properties').fetch('VpcSettings')
      expect(vpc_settings.fetch('SubnetIds')).to eq(['subnet-deadb33f'])
    end

    it 'sets VpcSettings.VpcId' do
      vpc_settings = simple_ad_json.fetch('Properties').fetch('VpcSettings')
      expect(vpc_settings.fetch('VpcId')).to eq('vpc-deadb33f')
    end

    private

    def simple_ad_json
      JSON.parse(simple_ad_template.to_json)
          .fetch('Resources')
          .fetch('SimpleActiveDirectory')
    end
  end
end
