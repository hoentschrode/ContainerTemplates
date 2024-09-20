#!/bin/bash

source ./.env

BUILD_TAG=latest

# 
#  -v "${HOST_CODE_PATH}":"${CODE_PATH}" \
#  
#  -v nvim_logs:/var/log \
podman run \
  --platform=linux/amd64 \
  --rm \
  --env-file ./.env \
  --user ide \
  --userns=keep-id \
  -v lht-removal-tool-nvim-cache:/home/${DEFAULT_USER}/.cache/nvim \
  -v lht-removal-tool-nvim-cache:/home/${DEFAULT_USER}/.local/share/nvim \
  -v lht-removal-tool-log:/var/log \
  -v "${HOST_CODE_PATH}":"${CODE_PATH}" \
  -i \
  -t localhost/lht-removal-tool:${BUILD_TAG} \
  zsh

set +x;
