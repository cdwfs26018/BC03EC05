moved {
  from = docker_container.instance
  to   = docker_container.instance["ubuntu-instance"]
}
