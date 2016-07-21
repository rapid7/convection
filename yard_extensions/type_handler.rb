# A YARD handler to deal with the "type" DSL method.
class TypeDslHandler < YARD::Handlers::Ruby::Base
  IRREGULAR_SLUGS ||= {
    'AWS::ElasticLoadBalancing::LoadBalancer' => 'aws-properties-ec2-elb.html'
  }.freeze

  handles method_call(:type)
  namespace_only # Do not process nested method calls.

  def process
    name = call_params.first.dup
    slug = slug_for_name(name)
    url = "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/#{slug}"
    namespace.docstring << "\n\nSee also the CloudFormation documentation for {#{url} #{name}}."
  end

  private

  def slug_for_name(name)
    return IRREGULAR_SLUGS[name] if IRREGULAR_SLUGS.key?(name)

    name.downcase.gsub('::', '-').sub('aws-', 'aws-resource-').concat('.html')
  end
end
