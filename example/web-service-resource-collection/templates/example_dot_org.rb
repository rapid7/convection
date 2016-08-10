require 'convection'
require_relative '../resources/web_service.rb'

module Templates
  EXAMPLE_DOT_ORG = Convection.template do
    description 'An example website to demonstrate using custom resource collections.'

    web_service 'ExampleDotOrg' do
      ec2_instance_image_id 'ami-45026036'

      user_data <<~USER_DATA
        #!/bin/bash
        apt-get update
        apt-get install -y unzip curl nginx
        service nginx start
        update-rc.d nginx defaults
      USER_DATA
    end
  end
end
