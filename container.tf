resource "docker_container" "instance" {
  name     = "tp-${var.os}-instance"
  image    = docker_image.os[var.os].image_id
  platform = local.allowed_os_images[var.os].platform

  command     = ["sleep", "infinity"]
  cpus        = var.cpu_max
  memory      = var.mem_max
  memory_swap = var.mem_max * 2

  must_run = true
  start    = true

  lifecycle {
    precondition {
      condition     = contains(keys(local.allowed_os_images), var.os)
      error_message = "L'image demandee doit correspondre a un OS autorise : ubuntu ou arch."
    }
  }
}
