#!/usr/bin/env bash

# git stash
# git pull origin master
# git stash pop

application_installed(){

  command -v "$1" >/dev/null 2>&1
}

add_dotfiles(){

  if [ -r "$1/dotfiles" ] && [ -d "$1/dotfiles" ]; then

    bsname=$(basename $1)

    if [ -r "$1/dotfiles/$HOME" ] && [ -d "$1/dotfiles/$HOME" ]; then

      ln -sf $1/dotfiles/$HOME/.[^.]* ~/

    fi

    if [ "$bsname" == "$OS" ]; then

      for file in $1/dotfiles/.[^.]* ; do

        sudo mkdir -p "$DOTFILES/$(basename $(dirname "$1"))"
        sudo ln -sf $file $DOTFILES/$(basename $(dirname "$1"))/.$OS$(basename "$file")

      done;

    else
      sudo mkdir -p "$DOTFILES/$bsname"
      sudo ln -sf $1/dotfiles/.[^.]* $DOTFILES/$bsname/
    fi

  fi

}

install_application(){

  if ! application_installed "$(basename "$1")";  then
    include "$1/pre-install.sh" "$1/install.sh"
    add_dotfiles "$1"
    include "$1/post-install.sh"
  else
    echo "Updating $(basename $1)"
    include "$1/update.sh"
  fi
}


# su - $USER

if [ -z "$USR_SRC" ]; then
  export USR_SRC="/usr/local/src";
fi

sudo mkdir -p $USR_SRC
sudo chmod -R ug+w $USR_SRC;

# # run from location with write permissions
# cd ~/

if [ -z "$GIT_ARCHIVE" ]; then
  export GIT_ARCHIVE="$USR_SRC/git";
fi

sudo mkdir -p $GIT_ARCHIVE

if [ -z "$DOTFILES" ]; then
  export DOTFILES="$USR_SRC/dotfiles";
fi
sudo mkdir -p $DOTFILES


GIT_DOMAIN_USERNAME_REPONAME="github.com/tarranjones/setup" #try to create dynamically

REPO_DIR="$GIT_ARCHIVE/$GIT_DOMAIN_USERNAME_REPONAME"

OS=$( uname -s | tr '[:upper:]' '[:lower:]')
PLATFORM_DIR=$REPO_DIR/$OS
APPLICATIONS_DIR=$REPO_DIR/applications
PLATFORM_APPLICATIONS_DIR=$PLATFORM_DIR/applications



# sudo chown -R $(id -u):$(id -g) "$(git rev-parse --show-toplevel)/.git/"
if [ -r "$REPO_DIR/.git" ] && [ -d "$REPO_DIR/.git" ]; then
  sudo chown -R $USER $REPO_DIR/.git/
fi
if ! git -C $REPO_DIR pull 2>/dev/null ; then
    sudo rm -rf $REPO_DIR
    sudo git clone https://$GIT_DOMAIN_USERNAME_REPONAME.git $REPO_DIR
    sudo chown -R $USER $REPO_DIR/.git/
fi

sudo git -C $REPO_DIR submodule update --init --recursive --remote --merge


# COPY DEVELOPMENT VERSION TO REPO_DIR (INSTEAD OF OUTOFDATE GIT REPO)
#############################################
sudo rm -fr $REPO_DIR/*
sudo cp -Rf $(dirname $0)/ $REPO_DIR/
sudo mkdir $REPO_DIR/dotfiles
sudo git clone https://github.com/tarranjones/dotfiles.git
cd $REPO_DIR # just so we dont do anything to the dev directory
##############################################


# source some helper functions and variables
[ -r $REPO_DIR/dotfiles/.env ] && [ -f $REPO_DIR/dotfiles/.env ] && . $REPO_DIR/dotfiles/.env
[ -r $REPO_DIR/dotfiles/.functions ] && [ -f $REPO_DIR/dotfiles/.functions ] && . $REPO_DIR/dotfiles/.functions

recursive_install(){

  if [ -r "$1" ] && [ -d "$1" ]; then
    echo "Installing $(basename $(dirname $1))/$(basename $1)"
    include "$1/pre-install.sh" "$1/install.sh"
    add_dotfiles "$1"
    include "$1/post-install.sh"
  fi

  if [ -r "$1/$OS" ] && [ -d "$1/$OS" ]; then
    recursive_install "$1/$OS"
  fi

  if [ -r "$1/applications" ] && [ -d "$1/applications" ]; then
    for app_dir in $1/applications/* ; do
      recursive_install $app_dir
    done;
  fi
}
recursive_install $REPO_DIR


$REPO_DIR/dotfiles/bootstrap.sh






