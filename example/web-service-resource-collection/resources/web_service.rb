require 'convection'

class WebService < Convection::Model::Template::ResourceCollection
  attach_to_dsl(:web_service)

  attribute :ec2_instance_image_id
  attribute :user_data

  def execute
    web_service = self

    generate_security_groups(web_service)
    generate_ec2_instance(web_service)
  end

  def cidr_ranges
    @cidr_ranges ||= allowed_csv_ranges.split(/[, ]+/)
  end

  # Resource generator methods

  def generate_ec2_instance(web_service)
    ec2_instance "#{name}Frontend" do
      image_id web_service.ec2_instance_image_id
      security_group fn_ref("#{web_service.name}SecurityGroup")

      tag 'Name', "#{web_service.name}Frontend"
      tag 'Stack', stack.cloud

      user_data base64(web_service.user_data)

      with_output 'Hostname', get_att(name, 'PublicDnsName') do
        description 'The public hostname of this web service.'
      end

      with_output 'HttpEndpoint', join('', 'http://', get_att(name, 'PublicDnsName')) do
        description 'The URL to visit this web service at.'
      end
    end
  end

  def generate_security_groups(web_service)
    ec2_security_group "#{web_service.name}SecurityGroup" do
      description "EC2 Security Group for the #{web_service.name} web service."

      web_service.cidr_ranges.each do |range|
        ingress_rule(:tcp, 80, range)
      end

      tag 'Name', "sg-#{web_service.name}-#{stack.cloud}".downcase
      tag 'Service', web_service.name
      tag 'Stack', stack.cloud

      with_output
    end
  end

  def allowed_csv_ranges
    return ENV['ALLOWED_CIDR_RANGES'] if ENV.key?('ALLOWED_CIDR_RANGES')

    raise ArgumentError, "You must export $ALLOWED_CIDR_RANGES to diff/converge #{stack.cloud_name}."
  end
end
