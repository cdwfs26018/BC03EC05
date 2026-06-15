#!/usr/bin/env bash
set -euo pipefail

TFVARS_FILE="terraform.tfvars"

docker_bin() {
  if command -v docker >/dev/null 2>&1; then
    command -v docker
    return
  fi

  if [ -x /Applications/Docker.app/Contents/Resources/bin/docker ]; then
    printf '%s\n' /Applications/Docker.app/Contents/Resources/bin/docker
    return
  fi

  printf 'Docker est introuvable.\n' >&2
  exit 1
}

terraform_cmd() {
  local docker
  docker="$(docker_bin)"
  PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH" "$docker" run --rm \
    -v "$PWD:/workspace" \
    -v "$HOME/.docker/run/docker.sock:/var/run/docker.sock" \
    -e DOCKER_HOST=unix:///var/run/docker.sock \
    -w /workspace \
    hashicorp/terraform:1.15.6 "$@"
}

hcl_escape() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  printf '%s' "$value"
}

insert_map_block() {
  local map_name="$1"
  local block="$2"
  local tmp_file
  tmp_file="$(mktemp)"

  awk -v map="$map_name" -v block="$block" '
    $0 ~ "^" map " = \\{" {
      in_map = 1
      depth = 0
    }
    in_map {
      depth += gsub(/\{/, "{")
      depth -= gsub(/\}/, "}")
      if (depth == 0) {
        print block
        in_map = 0
      }
    }
    { print }
  ' "$TFVARS_FILE" >"$tmp_file"

  mv "$tmp_file" "$TFVARS_FILE"
}

prompt_required() {
  local label="$1"
  local value=""

  while [ -z "$value" ]; do
    read -r -p "$label: " value
  done

  printf '%s' "$value"
}

create_vm() {
  local name os cpu_max ram_max public_key username password block

  name="$(prompt_required "Nom de l'instance")"
  os="$(prompt_required "OS (ubuntu ou arch)")"
  cpu_max="$(prompt_required "CPU max (ex: 1.0)")"
  ram_max="$(prompt_required "RAM max en MB (ex: 256)")"
  public_key="$(prompt_required "Cle publique SSH")"
  username="$(prompt_required "Nom d'utilisateur")"
  password="$(prompt_required "Mot de passe")"

  block="
  $(hcl_escape "$name") = {
    os         = \"$(hcl_escape "$os")\"
    cpu_max    = \"$(hcl_escape "$cpu_max")\"
    mem_max    = $ram_max
    public_key = \"$(hcl_escape "$public_key")\"
    username   = \"$(hcl_escape "$username")\"
    password   = \"$(hcl_escape "$password")\"
  }"

  insert_map_block "instances" "$block"
  terraform_cmd fmt
}

create_rds() {
  local name engine username password block

  name="$(prompt_required "Nom de l'instance RDS")"
  engine="$(prompt_required "Moteur (postgres ou mariadb)")"
  username="$(prompt_required "Nom d'utilisateur RDS")"
  password="$(prompt_required "Mot de passe RDS")"

  block="
  $(hcl_escape "$name") = {
    engine   = \"$(hcl_escape "$engine")\"
    username = \"$(hcl_escape "$username")\"
    password = \"$(hcl_escape "$password")\"
  }"

  insert_map_block "rds_instances" "$block"
  terraform_cmd fmt
}

main() {
  local answer rds_answer apply_answer

  read -r -p "Souhaitez-vous creer une nouvelle vm ? [o/N] " answer
  case "$answer" in
    o|O|oui|Oui|OUI)
      create_vm
      ;;
    *)
      printf 'Aucune VM ajoutee.\n'
      ;;
  esac

  read -r -p "Souhaitez-vous creer une instance de moteur de base de donnees ? [o/N] " rds_answer
  case "$rds_answer" in
    o|O|oui|Oui|OUI)
      create_rds
      ;;
    *)
      printf 'Aucune instance RDS ajoutee.\n'
      ;;
  esac

  read -r -p "Executer terraform apply maintenant ? [o/N] " apply_answer
  case "$apply_answer" in
    o|O|oui|Oui|OUI)
      terraform_cmd apply -input=false -auto-approve
      ;;
    *)
      printf 'terraform.tfvars a ete mis a jour sans appliquer.\n'
      ;;
  esac
}

main "$@"
