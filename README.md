Convection
==========

_A fully generic, modular DSL for AWS CloudFormation_ [![Build Status](https://travis-ci.org/rapid7/convection.svg)](https://travis-ci.org/rapid7/convection)

This gem aims to provide a reusable model for AWS CloudFormation in Ruby. It exposes a DSL for template definition, and a simple, decoupled abstraction of a CloudFormation Stack to compile and apply templates.

## Contributing

This repository will follow a 'Golden Master' release model to ensure a high level of code stability and legacy support for consumers.

* Pre-release branches (named `vX.Y`) will accept pull-requests from forks and feature branches.
* `master` will only accept merges from stable pre-release branches.
* Once a newer pre-release branch is released, older pre-release branches will enter maintenance mode, during which bug-fixes will be accepted and released at patch versions periodically.
* After two major releases, maintenance branches will become deprecated, and will no longer accept any merges (e.g. release 3.0.0 deprecates all 1.x branches).

The effect of this policy is such that two major versions will retain some level of support at any given time.

## Current Branches

### v0.2

This code-line is in the process of being deprecated in favor of version 1.0 of Convection, which is in active development (see [below](#v10)). Note that this conflicts with the policy above due to the radical scope of the refactor to version 1.0.0.

Commits are automatically tagged and released to [rubygems.org](https://rubygems.org/gems/convection) with `0.2.x` versions.

* **[Current]** Feature updates to this branch will continue to be merged while `v1.0` remains non-functional.
* **[Current]** Bug-fixes will continue to be merged to this branch until version 1.0.0 of Convection is released.

### v1.0

This is the development code-line for version 1.0.x of Convection. It will be published to [rubygems.org](https://rubygems.org/gems/convection) as pre-release versions of the next release periodically until changes stabilize.

**[Soon] Changes to Convection should be submitted as pull-requests to this branch.**

This branch will be merged to master for releases of version 1.0.x of Convection until such a time as version 1.1.0 is ready for release. At that time, only bug-fixes will continue to be merged to and released from this branch, but will no longer be merged back to master.

### master

This is the current stable version of Convection.

Commits will be automatically tagged and released to [rubygems.org](https://rubygems.org/gems/convection) with incrementing Semver versions beginning with 1.0.0 (0.x versions will never be released from `master`).

Changes will only be merged to this branch from the latest stable pre-release branch (e.g. `v1.0`, `v1.1`, etc.)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'convection'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install convection

## License

_Copyright (c) 2015 Rapid7 Inc. <coreservices@rapid7.com>_

```
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
