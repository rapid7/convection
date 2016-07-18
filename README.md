# Convection [![Build Status](https://travis-ci.org/rapid7/convection.svg)](https://travis-ci.org/rapid7/convection)
_A fully generic, modular DSL for AWS CloudFormation_

This gem aims to provide a reusable model for AWS CloudFormation in Ruby. It exposes a DSL for template definition, and a simple, decoupled abstraction of a CloudFormation Stack to compile and apply templates.

## Contributing
Please read our [Contributing guidelines](CONTRIBUTING.md) for more information on contributing to Convection.

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
- To converge all stacks in your cloudfile run `convection converge`. If you provide the name of your stack as a additional argument such as `convection converge my-stack-name` then all stacks above and including the stack you specified will be converged.

###### Diff
- To display diff between your local changes and the version of your stack in cloud formation of your changes run `convection diff`.

###### Help
- To print out a list of available cli options with their descriptions run `convection help`.

###### Print
- To print out the cloud formation template for a specific stack run `convection print my-stack-name`.

###### Validate
- To validate your stack is not missing a required resource run `convection validate my-stack-name`.

##Documentation
We highly recommend consulting the [getting started guide](https://github.com/rapid7/convection/blob/master/documentation/getting-started.md) for a in depth walk through on how to to set up your project and create and deploy a stack. Example stacks and resources are available in the [convection/example](https://github.com/rapid7/convection/tree/master/example) folder


## License
_Copyright (c) 2015 John Manero, Rapid7 LLC._

```
MIT License
===========

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

```
