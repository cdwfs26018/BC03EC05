variable "os" {
  description = "OS demande pour le conteneur applicatif."
  type        = string
  default     = "ubuntu"

  validation {
    condition     = contains(["ubuntu", "arch"], var.os)
    error_message = "La variable os doit valoir ubuntu ou arch."
  }
}

variable "cpu_max" {
  description = "Nombre maximal de CPU utilisables par le conteneur."
  type        = string
  default     = "1.0"
}

variable "mem_max" {
  description = "Limite memoire du conteneur en MB."
  type        = number
  default     = 256
}
