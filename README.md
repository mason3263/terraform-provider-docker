<a href="https://docker.com">
    <img src="https://raw.githubusercontent.com/bierwirth-it/terraform-provider-docker/master/assets/docker-logo.png" alt="Docker logo" title="Docker" align="right" height="100" style="background: white; border: white solid 5px" />
</a>
<a href="https://terraform.io">
    <img src="https://raw.githubusercontent.com/bierwirth-it/terraform-provider-docker/master/assets/terraform-logo.png" alt="Terraform logo" title="Terraform" align="right" height="100" style="background: white; border: white solid 0" />
</a>
<a href="https://bierwirth-it.de">
    <img src="http://bierwirth-it.de/img/logo.png" alt="Bierwirth-IT logo" title="Bierwirth-IT" align="right" height="100" style="background: white; border: white solid 5px" border="white solid5px" />
</a>

# Terraform Provider for multihost Docker

[![Release](https://img.shields.io/github/v/release/bierwirth-it/terraform-provider-docker)](https://github.com/bierwirth-it/terraform-provider-docker/releases)
[![Installs](https://img.shields.io/badge/dynamic/json?logo=terraform&label=installs&query=$.data.attributes.downloads&url=https%3A%2F%2Fregistry.terraform.io%2Fv2%2Fproviders%2F713)](https://registry.terraform.io/providers/bierwirth-it/docker)
[![Registry](https://img.shields.io/badge/registry-doc%40latest-lightgrey?logo=terraform)](https://registry.terraform.io/providers/bierwirth-it/docker/latest/docs)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/bierwirth-it/terraform-provider-docker/blob/main/LICENSE)  
[![Go Status](https://github.com/bierwirth-it/terraform-provider-docker/workflows/Acc%20Tests/badge.svg)](https://github.com/bierwirth-it/terraform-provider-docker/actions)
[![Lint Status](https://github.com/bierwirth-it/terraform-provider-docker/workflows/golangci-lint/badge.svg)](https://github.com/bierwirth-it/terraform-provider-docker/actions)
[![Go Report Card](https://goreportcard.com/badge/github.com/bierwirth-it/terraform-provider-docker)](https://goreportcard.com/report/github.com/bierwirth-it/terraform-provider-docker)  

## Forked from

https://github.com/kreuzwerker/terraform-provider-docker

## Documentation

The documentation for the provider is available on the [Terraform Registry](https://registry.terraform.io/providers/bierwirth-it/docker/latest/docs).

Do you want to migrate from `v2.x` to `v3.x`? Please read the [migration guide](docs/v2_v3_migration.md)

## Example usage

Take a look at the examples in the [documentation](https://registry.terraform.io/providers/bierwirth-it/docker/3.0.3/docs) of the registry
or use the following example:


```hcl
# Set the required provider and versions
terraform {
  required_providers {
    # We recommend pinning to the specific version of the Docker Provider you're using
    # since new versions are released frequently
    docker = {
      source  = "bierwirth-it/docker"
    }
  }
}

variable "hosts" {
  description = "Map of variables for hosts"
  default = {
    "001": { name: "sample", ip: "192.168.0.91" }
    "002": { name: "sample", ip: "192.168.0.92" }
    "003": { name: "sample", ip: "192.168.0.93" }
  }
}

# Configure the docker provider
provider "docker" {
}

# Create a docker image resource
# -> docker pull nginx:latest
resource "docker_image" "nginx" {
  for_each   = var.hosts
  override {
    host = "ssh://root@${each.value.ip}:22"
  }

  name         = "nginx:latest"
}

# Create a docker container resource
# -> same as 'docker run --name nginx -p8080:80 -d nginx:latest'
resource "docker_container" "nginx" {
  for_each   = var.hosts
  override {
    host = "ssh://root@${each.value.ip}:22"
  }

  name    = "nginx"
  image   = docker_image.nginx[each.key].image_id
  hostname = "${each.value.name}-${each.key}"

  ports {
    external = 8080
    internal = 80
  }
}
```

## Building The Provider

[Go](https://golang.org/doc/install) 1.18.x (to build the provider plugin)


```sh
$ git clone git@github.com:bierwirth-it/terraform-provider-docker
$ make build
```

## Contributing

The Terraform Docker Provider is the work of many of contributors. We appreciate your help!

To contribute, please read the contribution guidelines: [Contributing to Terraform - Docker Provider](CONTRIBUTING.md)

## License

The Terraform Provider Docker is available to everyone under the terms of the Mozilla Public License Version 2.0. [Take a look the LICENSE file](LICENSE).
