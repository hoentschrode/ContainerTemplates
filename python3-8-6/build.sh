#!/bin/sh
source ./.env
#source ./SUDO_PASSWORD
read -p '[var]: Enter root passwd for container user: ' SUDO_PASSWORD

#export https_proxy=${HTTPS_PROXY}

podman build \
  -f Dockerfile \
  --build-arg HOST_GID=$HOST_GID \
  --build-arg DEFAULT_USER=$DEFAULT_USER \
  --build-arg SUDO_PASSWORD=$SUDO_PASSWORD \
  -t lht-removal-tool \
  .

set +x;
