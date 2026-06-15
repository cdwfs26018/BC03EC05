locals {
  docker_image_platform = "linux/amd64"

  allowed_os_images = {
    ubuntu = "ubuntu:latest"
    arch   = "archlinux:latest"
  }
}

resource "docker_image" "os" {
  for_each = local.allowed_os_images

  name         = each.value
  keep_locally = true
  platform     = local.docker_image_platform
}
