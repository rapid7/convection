# templates/vpc.rb
require 'convection'

module Templates
  VPC = Convection.template do
    description 'EC2 VPC Test Template'

    ec2_vpc 'TargetVPC' do
      network '10.10.10.0/23'

      with_output 'id'
    end
  end
end
