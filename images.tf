locals {
  allowed_os_images = {
    ubuntu = {
      name          = "tp-ubuntu:latest"
      platform      = null
      build_context = "${path.module}/images/ubuntu"
      dockerfile    = "Dockerfile"
    }
    arch = {
      name          = "archlinux:latest"
      platform      = "linux/amd64"
      build_context = null
      dockerfile    = null
    }
  }
}

resource "docker_image" "os" {
  for_each = local.allowed_os_images

  name         = each.value.name
  keep_locally = true
  platform     = each.value.platform
  triggers = each.value.build_context == null ? {} : {
    authorized_keys = filesha256("${each.value.build_context}/authorized_keys")
    dockerfile      = filesha256("${each.value.build_context}/${each.value.dockerfile}")
    start_ssh       = filesha256("${each.value.build_context}/start-ssh.sh")
  }

  dynamic "build" {
    for_each = each.value.build_context == null ? [] : [each.value]

    content {
      context     = build.value.build_context
      dockerfile  = build.value.dockerfile
      build_args  = local.ubuntu_build_args
      pull_parent = true
      tag         = [build.value.name]
    }
  }
}
