# Contributing to Convection
The following document is a list of guidelines for making contributing to the Convection project.

## Table Of Contents
* [Developing](#developing)
  * [Branches](#branches)

## Developing
### Branches
We strive to use [Semantic Versioning](http://semver.org) as much as possible for convection.

### `master`
**NOTE**: The `master` branch is fully supported by the convection maintainers.

The latest and greatest code that we intend to release to Rubygems is merged into this branch.
Today that code happens to be part of the `v0.2.x` minor version since we have not deemed convection feature
complete (we'll release a `v1.0.0` release at that point).

Backwards incompatible changes until this time *may* be added by bumping the **minor** (not major) version of
the project. These will be explicitly called out in the release notes for the version that introduced them and if
possible a deprecation message and compatibility will be kept making users aware of a potential the breaking change in
the future.
