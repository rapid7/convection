require_relative '../lib/convection'

module Convection
  module Demo
    FOOBAR = Convection.template do
      description 'Demo Foobar'

      ec2_instance 'Foobar' do
        subnet stack.get('vpc', 'TargetVPCSubnetPublic3')
        security_group stack.get('security-groups', 'Foobar')

        image_id stack['foobar-image']
        instance_type 'm3.medium'
        key_name 'production'

        tag 'Name', 'foobar-0'
        tag 'Service', 'foobar'
        tag 'Stack', stack.cloud
      end

      #
      # Create an instance with encrypted EBS mount point
      # and an ephemeral volume
      #

      # Create a KMS encryption key to encrypt the volume
      kms_key 'FoobarKmsKey' do
        description 'Used to encrypt volumes'

        # don't delete the key when this stack is deleted
        deletion_policy 'Retain'

        policy do
          allow do
            sid 'Enable IAM User Permissions'
            principal :AWS => ["arn:aws:iam::#{MY_AWS_ACCOUNT_NUMBER}:root"]
            action 'kms:*'
            resource '*'
          end
        end
      end

      ec2_volume 'FoobarEncryptedVol' do
        availability_zone 'us-east-1a'
        size 20
        volume_type :gp2

        # encrypt with the key from this stack
        encrypted true
        kms_key fn_ref('FoobarKmsKey')

        # don't delete the volume when this stack is deleted
        deletion_policy 'Retain'

        tag 'Name', 'Foobar Encrypted Volume'
        tag 'Service', 'foobar'
        tag 'Stack', stack.cloud
      end

      ec2_instance 'FoobarWithEncryptedVol' do
        image_id stack['foobar-image']
        instance_type 'm3.medium'
        key_name 'production'
        availability_zone 'us-east-1a'

        # give the instance a static private IP and ensure
        # it has a public ip regardless of subnet default setting
        network_interface do
          private_ip_address '10.1.2.3'
          associate_public_ip_address true
          security_group stack.get('security-groups', 'Foobar')
          subnet stack.get('vpc', 'TargetVPCSubnetPublic3')
        end

        # mount the encrypted volume at /dev/xvdf
        volume do
          device '/dev/sdf'
          volume_id fn_ref('FoobarEncryptedVol')
        end

        # mount an ephemeral drive at /dev/xvdc
        block_device do
          device '/dev/sdc'
          virtual_name 'ephemeral0'
        end

        tag 'Name', 'Foobar Encrypted'
        tag 'Service', 'foobar'
        tag 'Stack', stack.cloud
      end
    end
  end
end
