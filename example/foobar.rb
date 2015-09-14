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
    end
  end
end
