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
  -v ide-python-3-8-6-nvim-cache:/home/${DEFAULT_USER}/.cache/nvim:Z,U \
  -v ide-python-3-8-6-nvim-cache:/home/${DEFAULT_USER}/.local/share/nvim:Z,U \
  -v ide-python-3-8-6-nvim-cache:/var/log \
  -v "${HOST_CODE_PATH}":"${CODE_PATH}" \
  -i \
  -t localhost/ide-python-3.8.6:${BUILD_TAG} \
  zsh

set +x;
