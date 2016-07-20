# tasks/lookup_vpc_task.rb
module Tasks
  class LookupVpcTask
    # REQUIRED: Convection expects tasks to respond to #call.
    def call(stack)
      @vpc_id = stack.get('vpc', 'id')
      @result = vpc_found?
    end

    # REQUIRED: Convection expects tasks to respond to #success?.
    def success?
      @result
    end

    # OPTIONAL: Convection emits the task as `task.to_s` in certain log messages.
    def to_s
      return 'VPC lookup' unless @vpc_id

      "VPC lookup of #{@vpc_id.inspect}"
    end

    private

    def vpc_found?
      true # XXX: This could be a call to the aws-sdk APIs.
    end
  end
end
