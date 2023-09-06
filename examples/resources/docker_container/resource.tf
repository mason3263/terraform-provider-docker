# Start a container
resource "docker_container" "ubuntu" {
  name  = "foo"
  image = docker_image.ubuntu.image_id
}

# Find the latest Ubuntu precise image.
resource "docker_image" "ubuntu" {
  name = "ubuntu:precise"
}

# Do the same on three remote hosts
variable "hosts" {
  description = "Map of variables for hosts"
  default = {
    "001" : { name : "sample", ip : "192.168.0.91" }
    "002" : { name : "sample", ip : "192.168.0.92" }
    "003" : { name : "sample", ip : "192.168.0.93" }
  }
}

# Find the latest Ubuntu precise image.
resource "docker_image" "ubuntu_images" {
  for_each = var.hosts
  override {
    host = "ssh://root@${each.value.ip}:22"
  }
  name = "ubuntu:precise"
}

# Start a container
resource "docker_container" "ubuntu_sample_hosts" {
  for_each = var.hosts
  override {
    host = "ssh://root@${each.value.ip}:22"
  }

  image    = docker_image.ubuntu_images[each.key].image_id
  name     = "foo"
  hostname = "${each.value.name}-${each.key}"
}
