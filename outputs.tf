output "ssh_ports" {
  description = "Ports SSH attribues dynamiquement par Docker pour les instances Ubuntu."
  value = {
    for key, instance in docker_container.instance :
    key => try(instance.ports[0].external, null)
    if var.instances[key].os == "ubuntu"
  }
}
