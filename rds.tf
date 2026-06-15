locals {
  allowed_rds_images = {
    postgres = "postgres:latest"
    mariadb  = "mariadb:latest"
  }

  rds_data_paths = {
    postgres = "/var/lib/postgresql"
    mariadb  = "/var/lib/mysql"
  }

  instance_rds = var.rds_instances
}

resource "docker_image" "rds" {
  for_each = local.allowed_rds_images

  name         = each.value
  keep_locally = true
}

resource "docker_container" "rds" {
  for_each = local.instance_rds

  name  = "tp-rds-${each.key}"
  image = docker_image.rds[each.value.engine].image_id
  tmpfs = {
    (local.rds_data_paths[each.value.engine]) = "rw,size=256m"
  }

  env = each.value.engine == "postgres" ? [
    "POSTGRES_USER=${each.value.username}",
    "POSTGRES_PASSWORD=${each.value.password}",
    "POSTGRES_DB=${each.key}",
    ] : [
    "MARIADB_USER=${each.value.username}",
    "MARIADB_PASSWORD=${each.value.password}",
    "MARIADB_DATABASE=${each.key}",
    "MARIADB_ROOT_PASSWORD=${each.value.password}",
  ]

  must_run = true
  start    = true
}
