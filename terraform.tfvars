instances = {
  ubuntu-instance = {
    os      = "ubuntu"
    cpu_max = "1.0"
    mem_max = 256
  }

  arch-instance = {
    os      = "arch"
    cpu_max = "0.5"
    mem_max = 256
  }
}

default_username = "ubuntu"
default_password = "ubuntu"

rds_instances = {
  postgres-main = {
    engine   = "postgres"
    username = "app_user"
    password = "app_password"
  }

  mariadb-main = {
    engine   = "mariadb"
    username = "app_user"
    password = "app_password"
  }
}
