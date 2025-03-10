#!/bin/bash

# configs
current=$(pwd)
machine=''
working_dir="~/.nvim"

#function helpers
red () { tput setaf 1; echo $1; tput sgr0; }
green () { tput setaf 2; echo $1; tput sgr0; }
yellow () { tput setaf 3; echo $1; tput sgr0; }
magenta () { tput setaf 5; echo $1; tput sgr0; }

linkFile () {
  src=${1}
  trgt=${2}
  if [[ ! -L "${trgt}" && -e "${trgt}" ]]; then
    magenta "backing up ${trgt}..."
    mv ${trgt} ${trgt}.old
    ln -s ${src} ${trgt}
  elif [ ! -L ${trgt} ]; then
    magenta "${trgt} not existing, linking"
    ln -s ${src} ${trgt}
  else
    yellow "Skipping, ${trgt} already linked"
  fi
}

detectOS () {
  unameOut="$(uname -s)"
  case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=OSX;;
    *)          machine="UNKNOWN:${unameOut}"
  esac

  return machine
}

installVimPlug () {
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim -Esc "PlugInstall"
  nvim -Esc "PlugUpdate"
}

# detect OS
# symlink init file based on OS
# Install dependencies
  # Install Vim-Plug
# Install plugins
# Update Plugins
#
