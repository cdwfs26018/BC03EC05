variable "instances" {
  description = "Instances de conteneurs a provisionner."

  type = map(object({
    os         = string
    cpu_max    = string
    mem_max    = number
    public_key = optional(string, "")
    username   = optional(string)
    password   = optional(string)
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

variable "rds_instances" {
  description = "Instances de bases de donnees a provisionner."

  type = map(object({
    engine   = string
    username = string
    password = string
  }))

  validation {
    condition = alltrue([
      for instance in values(var.rds_instances) : contains(["postgres", "mariadb"], instance.engine)
    ])
    error_message = "Chaque instance RDS doit utiliser postgres ou mariadb."
  }
}
