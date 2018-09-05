require 'spec_helper'

class Convection::Model::Template
  describe self do
    let(:template) do
      Convection.template do
        description 'Test Template'

        ec2_instance 'TestInstance1' do
          availability_zone 'us-east-1'
          image_id 'ami-asdf83'
        end

        ec2_instance 'TestInstance2' do
          availability_zone 'us-west-1'
          image_id 'ami-lda34f'
          depends_on 'TestInstance1'
        end
      end
    end

    describe '#resource' do
      context 'when defining a predefined resource' do
        subject do
          Convection.template do
            resource 'FooInstance' do
              type 'AWS::EC2::Instance'
            end
          end
        end

        it 'warns the user when they are using a predefined resource.' do
          expect { subject.render }.to output(/.*already defined.*/).to_stderr
        end
      end

      context 'when defining a undefined resource' do
        subject do
          Convection.template do
            resource 'FooInstance' do
              type 'FakeResource'
            end
          end
        end

        it 'warns the user when they are using a undefined resource.' do
          expect { subject.render }.to_not output.to_stderr
        end
      end
    end

    describe '#diff' do
      context 'when diffing resources with delete_policy' do
        it 'emits create events when a delete_policy is added' do
          local = Convection.template do
            resource 'TestInstance' do
              type 'TestResource'
              deletion_policy 'Retain'
            end
          end

          remote = Convection.template do
            resource 'TestInstance' do
              type 'TestResource'
            end
          end

          created = [Convection::Model::Diff.new('Resources.TestInstance.DeletionPolicy', 'Retain', nil)]
          created.each { |event| event.action = :create }

          events = local.diff(remote.render)
          expect(events).to eq(created)
        end

        it 'emits retain events when a resource with a deletion_policy is removed' do
          local = Convection.template do
          end

          remote = Convection.template do
            resource 'TestInstance' do
              type 'TestResource'
              deletion_policy 'Retain'
            end
          end

          retained = [
            Convection::Model::Diff.new('Resources.TestInstance.Type', nil, 'TestResource'),
            Convection::Model::Diff.new('Resources.TestInstance.DeletionPolicy', nil, 'Retain')
          ]
          retained.each { |event| event.action = :retain }
          retained.sort!

          events = local.diff(remote.render)
          events.sort!

          expect(events).to eq(retained)
        end

        it 'emits delete events when a deletion_policy is removed' do
          local = Convection.template do
            resource 'TestInstance' do
              type 'TestResource'
            end
          end

          remote = Convection.template do
            resource 'TestInstance' do
              type 'TestResource'
              deletion_policy 'Retain'
            end
          end

          deleted = [Convection::Model::Diff.new('Resources.TestInstance.DeletionPolicy', nil, 'Retain')]
          deleted.each { |event| event.action = :delete }
          deleted.sort!

          events = local.diff(remote.render)
          events.sort!

          expect(events).to eq(deleted)
        end

        it 'emits delete events when properties are removed and resources are retained' do
          local = Convection.template do
            resource 'TestInstance' do
              type 'TestResource'
              deletion_policy 'Retain'
            end
          end

          remote = Convection.template do
            resource 'TestInstance' do
              type 'TestResource'
              property 'Key', 'Value'
              deletion_policy 'Retain'
            end
          end

          deleted = [Convection::Model::Diff.new('Resources.TestInstance.Properties.TestResource.Key', nil, 'Value')]
          deleted.each { |event| event.action = :delete }
          deleted.sort!

          events = local.diff(remote.render)
          events.sort!

          expect(events).to eq(deleted)
        end

        it 'emits delete events when properties are removed and resources are not retained' do
          local = Convection.template do
            resource 'TestInstance' do
              type 'TestResource'
              deletion_policy 'Retain'
            end
          end

          remote = Convection.template do
            resource 'TestInstance' do
              type 'TestResource'
              property 'Key', 'Value'
            end
          end

          created = [Convection::Model::Diff.new('Resources.TestInstance.DeletionPolicy', 'Retain', nil)]
          created.each { |event| event.action = :create }

          deleted = [Convection::Model::Diff.new('Resources.TestInstance.Properties.TestResource.Key', nil, 'Value')]
          deleted.each { |event| event.action = :delete }

          events = local.diff(remote.render)
          events.sort!

          expect(events).to eq((created + deleted).sort)
        end

        it 'only checks for DeletionPolicy events' do
          local = Convection.template do
          end

          remote = Convection.template do
            resource 'TestInstanceWithoutDeletionPolicy' do
              type 'TestResource'
            end

            resource 'TestInstanceWithDeletionPolicy' do
              type 'TestResource'
              deletion_policy 'Retain'
            end
          end

          deleted = [
            Convection::Model::Diff.new('Resources.TestInstanceWithoutDeletionPolicy.Type', nil, 'TestResource')
          ]
          deleted.each { |event| event.action = :delete }

          retained = [
            Convection::Model::Diff.new('Resources.TestInstanceWithDeletionPolicy.Type', nil, 'TestResource'),
            Convection::Model::Diff.new('Resources.TestInstanceWithDeletionPolicy.DeletionPolicy', nil, 'Retain')
          ]
          retained.each { |event| event.action = :retain }

          events = local.diff(remote.render)
          events.sort!

          expect(events).to eq((deleted + retained).sort)
        end
      end
    end

    subject do
      template_json
    end

    it 'template format version is 2010-09-09 ' do
      expect(subject['AWSTemplateFormatVersion']).to eq('2010-09-09')
    end

    it 'Template descriptions are set correctly' do
      expect(subject['Description']).to eq('Test Template')
    end

    it 'template TestInstance1 has properties' do
      expect(subject['Resources']['TestInstance1']['Properties']).to_not eq(nil)
    end

    it 'TestInstance1 Type is AWS::EC2::Instance' do
      expect(subject['Resources']['TestInstance1']['Type']).to eq('AWS::EC2::Instance')
    end

    it 'DependsOn values are set correctly' do
      expect(subject['Resources']['TestInstance2']['DependsOn'][0]).to eq('TestInstance1')
    end

    it { is_expected.to have_key('Parameters') }

    it { is_expected.to have_key('Mappings') }

    it { is_expected.to have_key('Conditions') }

    it { is_expected.to have_key('Resources') }

    private

    def template_json
      JSON.parse(template.to_json)
    end
  end
end
