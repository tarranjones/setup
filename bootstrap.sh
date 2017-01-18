#!/usr/bin/env bash

# this should be a makfile but for simplicity just run as a shell script

# all these functions should be in the makefile




if [ -z "$USR_SRC" ]; then
  export USR_SRC="/usr/local/src";
fi
sudo mkdir -p $USR_SRC
sudo chown -R $USER $USR_SRC

# # run from location with write permissions
# cd ~/

if [ -z "$GIT_ARCHIVE" ]; then
  export GIT_ARCHIVE="$USR_SRC/git";
fi
sudo mkdir -p $GIT_ARCHIVE

if [ -z "$DOTFILES" ]; then
  export DOTFILES="$USR_SRC/dotfiles";
  #create symlink or overwrite default var
fi
sudo mkdir -p $DOTFILES

GIT_DOMAIN_USERNAME_REPONAME="github.com/tarranjones/setup" #try to create dynamically

REPO_DIR="$GIT_ARCHIVE/$GIT_DOMAIN_USERNAME_REPONAME"

sudo mkdir -p $REPO_DIR;

if ! git -C $REPO_DIR pull; then
  sudo rm -rf $REPO_DIR
  sudo git clone https://$GIT_DOMAIN_USERNAME_REPONAME.git $REPO_DIR
fi

cd $REPO_DIR

git -C $REPO_DIR submodule update --init --recursive --remote --merge

DOTFILE_DIRNAME="$REPO_DIR/dotfiles"

[ -r $DOTFILE_DIRNAME/.env ] && [ -f $DOTFILE_DIRNAME/.env ] && . $DOTFILE_DIRNAME/.env
[ -r $DOTFILE_DIRNAME/.functions ] && [ -f $DOTFILE_DIRNAME/.functions ] && . $DOTFILE_DIRNAME/.functions

# symlink dir
# sudo rm -r $DOTFILES;
# sudo ln -sf "$DOTFILE_DIRNAME" $DOTFILES

# symlink files not dir
sudo mkdir -p $DOTFILES
sudo ln -sf "$DOTFILE_DIRNAME/*" $DOTFILES/


OS=$( uname -s | tr '[:upper:]' '[:lower:]')

if [ -d $REPO_DIR/platform/$OS/dotfiles ]; then

  #Run OS install preferences/ defaults
  [ -r "$REPO_DIR/platfrom/$OS/install.sh" ] && [ -f "$REPO_DIR/platfrom/$OS/install.sh" ] && ."$REPO_DIR/platfrom/$OS/install.sh"
  sudo ln -sf "$REPO_DIR/platform/$OS/dotfiles" "$DOTFILES/$OS"

fi

#single $OS only Applicaions - system package managers, terminals etc- homebrew, linuxbrew, Chocolatey, iterm, babun, scoop)
#kept seperate because they most likely need installing first
for app_dir in $REPO_DIR/plaform/$OS/applications/*; do

  if [ -r "$dir" ] && [ -d "$dir" ]; then

    install_application "$dir";

  fi

done;

for app_dir in $REPO_DIR/applications/*/; do

  if [ -r "$app_dir" ] && [ -d "$app_dir" ]; then

    #cross platform install
    install_application "$app_dir";

    if [ -r "$app_dir/$OS" ] && [ -d "$app_dir/$OS" ]; then

      # platform specific install
      install_application "$app_dir/$OS";
    fi

  fi

done;

include(){

  for $file in "$@"; do

    echo $file;

    [ -r $file ] && [ -f $file ] && . $file

  done;

}

add_dotfiles(){

  echo $1

  # if [ -r "$1/dotfiles" ] && [ -d "$1/dotfiles" ]; then

  #   echo $1
  # fi

  # no platform specific dotfile directory symlink to

  # setup/platform/darwin/dotfiles/* /dotfiles/
  # setup/dotfiles/* /dotfiles/

  # setup/platform/darwin/applications/bash/dotfiles/* /dotfiles/bash/
  # setup/applications/bash/dotfiles/* /dotfiles/bash/

  # eg
  # rm -f /dotfiles/bash/*
  # http://www.linuxquestions.org/questions/linux-general-1/symlink-two-dirs-into-one-327587/
  # ln -s setup/applications/bash/dotfiles/* /dotfiles/bash/
  # ln -s setup/platform/darwin/applications/bash/dotfiles/* /dotfiles/bash/

  # ln -s setup/platform/dotfiles/* /dotfiles/


  # # very possible naming clash
  # either rename and spport sourcing {$name}.{functions,.env)
  # or
  # concat files
  # # http://superuser.com/questions/762590/can-i-create-a-symlink-esque-file-to-merge-two-files-together


}
run_install_scripts(){
  include $1/pre-install.sh $1/install.sh $1/post-install.sh
  # npm install
  # composer install

}
install_application(){
  run_install_scripts $1
  # if installed else add remove
  add_dotfiles $1
}


