# uses the 'latest' tag
data "docker_image" "latest" {
  name = "nginx"
}

# uses a specific tag
data "docker_image" "specific" {
  name = "nginx:1.17.6"
}

# use the image digest
data "docker_image" "digest" {
  name = "nginx@sha256:36b74457bccb56fbf8b05f79c85569501b721d4db813b684391d63e02287c0b2"
}

# uses the tag and the image digest
data "docker_image" "tag_and_digest" {
  name = "nginx:1.19.1@sha256:36b74457bccb56fbf8b05f79c85569501b721d4db813b684391d63e02287c0b2"
}

# overrides host Defaults from Provider
data "docker_image" "otherVM" {
  name = "nginx"
  override {
    host = "ssh://user@remote-host:22"
  }
}

# deploy image to multiple destinations
locals {
  hosts = {
    "100" : { name : "remote-host100", ip_address : "192.168.111.100" }
    "101" : { name : "remote-host101", ip_address : "192.168.111.101" }
  }
}

data "docker_image" "otherVMs" {
  for_each = local.hosts

  name = "nginx"
  override {
    host = "ssh://user@${each.value.name}:22"
  }
}
