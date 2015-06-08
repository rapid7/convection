#!/usr/bin/env ruby
require 'convection'

region = 'us-west-1'

elb_template = Convection.template do
  description 'Example ELB via Convection '

  elb 'TestELB' do
    availability_zones(
      {
        "Fn::GetAZs"=>""
      }
    )
    load_balancer_name('ExampleELB')
    listeners(
      {
         'InstancePort' => '80',
         'LoadBalancerPort' => '80',
         'Protocol' => 'HTTP'
      }
    )
  end
end

puts elb_template.to_json
#puts Convection.stack('ELBTestStack', elb_template, :region => region).apply
