resource "docker_container" "instance" {
  for_each = var.instances

  name  = "tp-${each.key}"
  image = docker_image.os[each.value.os].image_id

  command     = each.value.os == "ubuntu" ? ["/usr/sbin/sshd", "-D", "-e"] : ["sleep", "infinity"]
  cpus        = each.value.cpu_max
  memory      = each.value.mem_max
  memory_swap = each.value.mem_max * 2

  must_run = true
  start    = true

  lifecycle {
    precondition {
      condition     = contains(keys(local.allowed_os_images), each.value.os)
      error_message = "L'image demandee doit correspondre a un OS autorise : ubuntu ou arch."
    }
  }
}
