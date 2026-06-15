locals {
  instance_os = "ubuntu"
}

resource "docker_container" "instance" {
  name     = "tp-${local.instance_os}-instance"
  image    = docker_image.os[local.instance_os].image_id
  platform = local.allowed_os_images[local.instance_os].platform

  command  = ["sleep", "infinity"]
  must_run = true
  start    = true

  lifecycle {
    precondition {
      condition     = contains(keys(local.allowed_os_images), local.instance_os)
      error_message = "L'image demandee doit correspondre a un OS autorise : ubuntu ou arch."
    }
  }
}
