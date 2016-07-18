require 'spec_helper'

class Convection::Model::Template::Resource
  describe Lambda do
    let(:template) do
      Convection.template do
        description 'VPC Endpoint Test Template'

        ec2_vpc_endpoint 'TestVpcEndpoint' do
          service 's3'
          vpc 'vpc-foo'
          route_tables %w(table1 table2)

          allow do
            s3_resource 'bucket-bar', '*'
            action 's3:GetObject'
          end
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('TestVpcEndpoint')
        .fetch('Properties')
    end

    it 'vpc endpoint config is not nil' do
      expect(subject).to_not eq(nil)
    end

    it 'vpc is correctly defined' do
      expect(subject['VpcId']).to eq('vpc-foo')
    end

    it 'ServiceName is a hash' do
      expect(subject['ServiceName']).to be_a(Hash)
    end

    # "ServiceName"=>
    #   {"Fn::Join"=>[".", ["com.amazonaws", {"Ref"=>"AWS::Region"}, "s3"]]},
    it 'ServiceName Fn::Join is a array' do
      expect(subject['ServiceName']['Fn::Join']).to be_a(Array)
    end

    it 'ServiceName Fn::Join array index 0 is correctly defined' do
      expect(subject['ServiceName']['Fn::Join'][0]).to eq('.')
    end

    it 'ServiceName s3 path is an array' do
      expect(subject['ServiceName']['Fn::Join'][1]).to be_a(Array)
    end

    it 'ServiceName s3 path last element is s3' do
      expect(subject['ServiceName']['Fn::Join'][1].last).to eq('s3')
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
