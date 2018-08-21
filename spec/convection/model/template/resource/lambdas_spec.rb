require 'spec_helper'

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
          concurrency 100

          code do
            s3_bucket 'testbucket'
            s3_key 'testkey'
          end

          vpc_config do
            security_groups %w(group1 group2)
            subnets %w(subnet1a subnet1b)
          end

          dead_letter_config do
            target_arn 'arn:aws:sqs:us-east-1:XXXXXXXXXXXX:lambda-dlq'
          end

          tag 'test', 'value'
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

    it 'ReservedConcurrentExecutions matches the value defined in the template' do
      expect(subject['ReservedConcurrentExecutions']).to eq(100)
    end

    it 'dead letter config matches the value defined in the template' do
      expect(subject['DeadLetterConfig']['TargetArn']).to eq('arn:aws:sqs:us-east-1:XXXXXXXXXXXX:lambda-dlq')
    end

    it 'sets tags' do
      expect(subject['Tags']).to include(hash_including('Key' => 'test', 'Value' => 'value'))
    end

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
