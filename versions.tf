terraform {
  required_version = ">= 1.15.0, < 1.16.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.4.0"
    }
  }
}
