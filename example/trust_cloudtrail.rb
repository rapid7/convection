 require 'convection'

   module CLOUDTRAIL       
        #IAM role to create a log stream & put events
        iam_role 'role' do
         path "/"
         #creates trust policy
	 trust_cloudtrail
         
        policy 'CreateStreamPolicy' do
	  allow do
	    resource 'arn:aws:logs:*:*:*'
	    action 'logs:CreateLogStream'
	  end
        end

	policy 'PutEventsPolicy' do
	  allow do
	    resource 'arn:aws:logs:*:*:*'
	    action 'logs:PutLogEvents'
	     end
           end
       end
   end
