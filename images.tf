locals {
  allowed_os_images = {
    ubuntu = {
      name     = "ubuntu:latest"
      platform = null
    }
    arch = {
      name     = "archlinux:latest"
      platform = "linux/amd64"
    }
  }
}

resource "docker_image" "os" {
  for_each = local.allowed_os_images

  name         = each.value.name
  keep_locally = true
  platform     = each.value.platform
}
