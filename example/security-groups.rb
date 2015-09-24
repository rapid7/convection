require_relative '../lib/convection'

module Convection
  module Demo
    SECURITY_GROUPS = Convection.template do
      description 'Demo Security Groups'

      ec2_security_group 'FoobarELB' do
        vpc stack.get('vpc', 'id')
        description 'Foobar ELB Ingress'

        ingress_rule(:tcp, 80, '0.0.0.0/0')
        ingress_rule(:tcp, 443, '0.0.0.0/0')

        tag 'Name', "sg-foobar-elb-#{ stack.cloud }"
        tag 'Service', 'foobar'
        tag 'Resource', 'ELB'
        tag 'Scope', 'public'
        tag 'Stack', stack.cloud

        with_output
      end

      ec2_security_group 'Foobar' do
        vpc stack.get('vpc', 'id')
        description 'Foobar Ingress'

        ingress_rule(:tcp, 8080) { source_group fn_ref('FoobarELB') }

        tag 'Name', "sg-foobar-#{ stack.cloud }"
        tag 'Service', 'foobar'
        tag 'Resource', 'EC2'
        tag 'Scope', 'private'
        tag 'Stack', stack.cloud

        with_output
      end
    end
  end
end
