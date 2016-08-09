# Stackgroups
A stack_group is a collection of stacks defined as a string array in your cloudfile. A stack can be defined like the below example in your cloudfile.
```ruby
stack_group 'test', ['vpc','vpc2']
stack 'vpc', Templates::VPC
stack 'vpc2', Templates::VPC2
```
Once defined users can run converge or diff on a specific stack_group instead of the entirety of their cloud file. See below for examples
```text
convection diff --stack_group test
convection converge --stack_group test
```