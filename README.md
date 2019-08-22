# Packer - Golang Vagrant box

A packer project that creates a Vagrant box with Golang and some basic tools installed, based off another Vagrant box.

## Prerequisites

* Install [packer](https://www.packer.io/downloads.html).
* Install [vagrant](https://www.vagrantup.com/downloads.html).
* Ruby version ~> 2.5.1 for running KitchenCI test.

## Building the box with Packer

The packer template is in `template.json`. In the `variables` section you can set parameters to customize the build. Help on setting, overriding variables in packer can be found [here](https://www.packer.io/docs/templates/user-variables.html#setting-variables).

* `base_box`  - the base box to use. It needs to be a box published to Vagrant cloud so named `user/box`
* `golang_file` - the Golang file name to download and install e.g. `go1.12.9.linux-amd64.tar.gz`.
* `skip_add` - weather to skip adding the base box to vagrant. If the box is not already added packer will fail.
* `build_name` - used internally to set parameters of the packer builder. Changing it will change the path of the output artifact, so you will need to adjust parameter in other files like the `box_url` in `.kitchen.yml`.

Run `packer validate template.json` - to make basic template validation.

Run `packer build template.json` - to build the Vagrant box with packer.

## Testing with KitchenCI

The project includes a KitchenCI configuration to run basic tests against the box outputted from packer.

To run it you need to install the gems from the `Gemfile`. Its recommended to use ruby [`bundler`](https://bundler.io/).

Installing gems with bundler:

* `gem install bundler`
* `bundle install`

Running Kitchen tests:

* `bundle exec kitchen converge` - will build the test environment.
* `bundle exec kitchen verify` - will run the tests.
* `bundle exec kitchen destroy` - will destroy the test environment.
* `bundle exec kitchen test` - will perform the above steps with a single command.

## Uploading to Vagrant cloud

The project includes a script `scripts\vagrant_cloud_upload.sh` to upload the box to Vagrant cloud. It is basically a wrapper for the `vagrant cloud publish` [command](https://www.vagrantup.com/docs/cli/cloud.html#cloud-publish) so you can use it instead.

You need to set up Vagrant cloud access by setting the `VAGRANT_CLOUD_TOKEN` environment variable to your user token.

script usage: `scripts\vagrant_cloud_upload.sh [box_version]`, box_version will default to `yy.mm.dd` if not set.

## Example

```bash
packer validate template.json # basic template validation

packer build -var 'golang_file=go1.12.9.linux-amd64.tar.gz' template.json   # build the box with packer, setting the golang_ver variable.

bundle exec kitchen test # run tests

scripts/vagrant_cloud_upload.sh 1.12.9 # upload to Vagrant cloud
```
