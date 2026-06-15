resource "docker_image" "cadvisor" {
  name         = "gcr.io/cadvisor/cadvisor:latest"
  keep_locally = true
}

resource "docker_container" "cadvisor" {
  for_each = docker_container.instance

  name  = "tp-cadvisor-${each.key}"
  image = docker_image.cadvisor.image_id

  command = [
    "-docker_only=true",
    "-housekeeping_interval=30s",
  ]

  must_run = true
  start    = true

  ports {
    internal = 8080
  }

  volumes {
    host_path      = "/"
    container_path = "/rootfs"
    read_only      = true
  }

  volumes {
    host_path      = "/var/run"
    container_path = "/var/run"
    read_only      = false
  }

  volumes {
    host_path      = "/sys"
    container_path = "/sys"
    read_only      = true
  }

  volumes {
    host_path      = "/var/lib/docker"
    container_path = "/var/lib/docker"
    read_only      = true
  }
}
