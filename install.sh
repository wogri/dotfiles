#!/bin/bash

set -e
set -o pipefail

sudo apt update
sudo apt install -y ansible git

if [ -e dotfiles ]; then
  git -C dotfiles/ pull
else
  git clone --depth 1 https://github.com/wogri/dotfiles.git
fi

ansible-playbook dotfiles/dotfiles.yml
