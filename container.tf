resource "docker_container" "instance" {
  for_each = var.instances

  name  = "tp-${each.key}"
  image = docker_image.os[each.value.os].image_id

  command     = each.value.os == "ubuntu" ? ["/usr/local/bin/start-ssh.sh"] : ["sleep", "infinity"]
  cpus        = each.value.cpu_max
  memory      = each.value.mem_max
  memory_swap = each.value.mem_max * 2
  env = each.value.os == "ubuntu" ? [
    "INSTANCE_USERNAME=${coalesce(each.value.username, var.default_username)}",
    "INSTANCE_PASSWORD=${coalesce(each.value.password, var.default_password)}",
    "INSTANCE_PUBLIC_KEY=${each.value.public_key}",
  ] : []

  must_run = true
  start    = true

  lifecycle {
    precondition {
      condition     = contains(keys(local.allowed_os_images), each.value.os)
      error_message = "L'image demandee doit correspondre a un OS autorise : ubuntu ou arch."
    }
  }
}
