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

      ec2_security_group 'FoobarEgress' do
        vpc stack.get('vpc', 'id')
        description 'Foobar Egress'

        egress_rule(:tcp, 80, '0.0.0.0/0')
        egress_rule(:tcp, 443, '0.0.0.0/0')

        tag 'Name', "sg-foobar-egress-#{ stack.cloud }"
        tag 'Service', 'foobar'
        tag 'Resource', 'EC2'
        tag 'Scope', 'private'
        tag 'Stack', stack.cloud

        with_output
      end

      ec2_security_group 'FoobarNoEgress' do
        vpc stack.get('vpc', 'id')
        description 'Foobar No Egress'

        # By default, Cloud Formation adds a default egress rule that allows
        # egress traffic on all ports and IP protocols to any location.  The default
        # rule is removed only when you specify one or more egress rules.  If you want
        # to remove the default rule and limit egress traffic to just the localhost,
        # you can use the following rule:
        # See: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html
        egress_rule(-1, nil, '127.0.0.1/32')

        tag 'Name', "sg-foobar-noegress-#{ stack.cloud }"
        tag 'Service', 'foobar'
        tag 'Resource', 'EC2'
        tag 'Scope', 'private'
        tag 'Stack', stack.cloud

        with_output
      end
    end
  end
end
