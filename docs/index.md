# Convection [![Build Status](https://api.travis-ci.org/rapid7/convection.svg?branch=master)](https://travis-ci.org/rapid7/convection)
_A fully generic, modular DSL for AWS CloudFormation_

This gem aims to provide a reusable model for AWS CloudFormation in Ruby. It exposes a DSL for template definition, and a simple, decoupled abstraction of a CloudFormation Stack to compile and apply templates.

## Contributing
Please read our [Contributing guidelines](.github/CONTRIBUTING.md) for more information on contributing to Convection.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'convection'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install convection

##CLI Commands
###### Converging
- To converge all stacks in your cloudfile run `convection converge` in the same directory as your cloudfile or use `--cloudfiles` and specify the path to the cloudfile. If you provide the name of your stack as a additional argument such as `convection converge my-stack-name` then all stacks above and including the stack you specified will be converged.
- To converge a stack group run `convection converge --stack_group YOUR_STACK_GROUP_NAME`
- To converge a specific stack or a list of stacks run `convection converge --stacks stackA stackB ...`
- To converge multiple cloudfiles at the same time run use the `--cloudfiles`  option providing the path to the cloudfiles. Example `bundle exec convection converge --cloudfiles us-east-1/Cloudfile eu-central-1/Cloudfile`

###### Diff
- To display a diff between your local changes and the version of your stack in cloud formation of your changes run `convection diff`.
- To diff the changes in a stack group run `convection diff --stack_group YOUR_STACK_GROUP_NAME`
- To diff the changes for a specific stack or a list of stacks run `convection diff --stacks stackA stackB ...`

###### Help
- To print out a list of available cli options with their descriptions run `convection help`.

###### Print
- To print out the cloud formation template for a specific stack run `convection print-template my-stack-name`.

###### Validate
- To validate your stack is not missing a required resource run `convection validate my-stack-name`.

## Documentation
We highly recommend consulting the [getting started guide](./docs/getting-started.md) for a in depth walk through on how to to set up your project and create and deploy a stack. Example stacks and resources are available in the [convection/example](https://github.com/rapid7/convection/tree/master/example) folder

Additionally you can generate the Ruby API documentation by executing `bundle exec rake yard`.

## License
Convection is distributed under the MIT license - please refer to the [LICENSE](LICENSE.md) for more information.
