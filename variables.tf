variable "instances" {
  description = "Instances de conteneurs a provisionner."

  type = map(object({
    os      = string
    cpu_max = string
    mem_max = number
  }))

  validation {
    condition = alltrue([
      for instance in values(var.instances) : contains(["ubuntu", "arch"], instance.os)
    ])
    error_message = "Chaque instance doit demander un OS autorise : ubuntu ou arch."
  }
}

variable "default_username" {
  description = "Nom d'utilisateur par defaut configure dans l'image Ubuntu SSH."
  type        = string
}

variable "default_password" {
  description = "Mot de passe par defaut configure dans l'image Ubuntu SSH."
  type        = string
}
