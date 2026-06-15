# Etape 1 - Base Terraform Docker

## Objectif

Cette etape configure Terraform pour provisionner des ressources Docker sur la
machine qui heberge Docker Desktop.

Les versions sont figees pour eviter qu'une correction ulterieure utilise des
comportements differents :

- Terraform : `>= 1.15.0, < 1.16.0`
- Provider Docker : `kreuzwerker/docker` en version `4.4.0`

## Execution sur macOS via Docker

Le client Terraform est execute depuis le conteneur `hashicorp/terraform:1.15.6`.
Le dossier du projet est monte dans `/workspace` et le socket Docker de Docker
Desktop est monte dans le conteneur pour permettre au provider Docker de piloter
le daemon local.

```bash
PATH=/Applications/Docker.app/Contents/Resources/bin:$PATH \
/Applications/Docker.app/Contents/Resources/bin/docker run --rm \
  -v "$PWD:/workspace" \
  -v /Users/alexis/.docker/run/docker.sock:/var/run/docker.sock \
  -e DOCKER_HOST=unix:///var/run/docker.sock \
  -w /workspace \
  hashicorp/terraform:1.15.6 init
```

Le provider Docker utilise `unix:///var/run/docker.sock`, qui correspond au
socket Docker monte dans le conteneur Terraform.

## Choix du backend

Pour cette etape, aucun backend distant n'est configure. Le backend local par
defaut est suffisant car le sujet demande un depot Git local, sans remote
obligatoire, et le travail est individuel.

Un backend distant deviendrait utile pour partager l'etat Terraform entre
plusieurs operateurs, verrouiller les operations concurrentes et conserver un
historique centralise de l'etat d'infrastructure. Ici, l'ajouter augmenterait la
complexite sans besoin fonctionnel immediat.
