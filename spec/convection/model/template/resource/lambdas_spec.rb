require 'spec_helper'
require 'pp'
class Convection::Model::Template::Resource
  describe Lambda do
    let(:template) do
      Convection.template do
        description 'Conditions Test Template'

        lambda_function 'TestLambda' do
          description 'Test description'
          handler 'index.handler'
          runtime 'nodejs'
          role 'arn:aws:x:y:z'

          code do
            s3_bucket 'testbucket'
            s3_key 'testkey'
          end

          vpc_config do
            security_groups %w(group1 group2)
            subnets %w(subnet1a subnet1b)
          end
        end
      end
    end

    subject do
      template_json
        .fetch('Resources')
        .fetch('TestLambda')
        .fetch('Properties')
    end

    it 's3 bucket configurations match what is defined in the template' do
      expect(subject['Code']['S3Bucket']).to eq('testbucket')
      expect(subject['Code']['S3Key']).to eq('testkey')
    end

    it 'the role matches the value defined in the template' do
      expect(subject['Role']).to eq('arn:aws:x:y:z')
    end

    it 'vpc config parameters match the values defined in the template' do
      expect(subject['VpcConfig']).to_not eq(nil)
    end

    it 'security group ids are stored in an array' do
      expect(subject['VpcConfig']['SecurityGroupIds']).to be_a(Array)
    end

    it 'security groups is an array of 2 group ids' do
      expect(subject['VpcConfig']['SecurityGroupIds'].size).to eq(2)
    end

    it 'subnet ids are stored in an array' do
      expect(subject['VpcConfig']['SubnetIds']).to be_a(Array)
    end

    it 'SubnetIds is an array of 2 group ids' do
      expect(subject['VpcConfig']['SubnetIds'].size).to eq(2)
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
