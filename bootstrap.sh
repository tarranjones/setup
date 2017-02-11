#!/usr/bin/env bash

command_exists(){
  command -v "$(basename "$1")" >/dev/null 2>&1
}

install_command(){

  for path in "$@" ; do

    local cmd=$(basename -- $path);

    command_exists "$cmd" && echo "$cmd already Installed" && continue

    echo "Installing $cmd"

    install_package $REPO_DIR/packages/$cmd;

    brew install $cmd

    command_exists "$cmd" && echo "$cmd Installed" && continue

    echo "$cmd Failed to install"
  done;
}


dotfiles_dir(){

  if [ -r "$1" ] && [ -d "$1" ] && [ $(basename -- $1) == 'dotfiles' ]; then

    if [ -r $1/'$HOME' ] && [ -d $1/'$HOME' ]; then
      for item in $1/'$HOME'/.[^.]* ; do
        sudo ln -sf $item ~/
       done;
    fi

    dir_name=$DOTFILES

    if [ -n "$2" ]; then
      dir_name="$dir_name/$2/"
    fi

    sudo mkdir -p "$dir_name"

    if [ -z "$3" ]; then
      sudo ln -sf $1/.[^.]* $dir_name
    else
      for file in $1/.[^.]* ; do
        sudo ln -sf $file $dir_name/.$3$(basename "$file")
      done;
    fi
  fi
}

install_dir(){
  include $1/pre-install.sh $1/$OS.pre-install.sh $1/$OS/pre-install.sh
  include $1/install.sh $1/$OS.install.sh $1/$OS/install.sh
  for dir in $1/{,$OS/}; do
    [ -r "$dir/package.json" ] && [ -f "$dir/package.json" ] && install_command npm && npm install $dir
    [ -r "$dir/composer.json" ] && [ -f "$dir/composer.json" ] && install_command composer && composer install $dir
    [ -r "$dir/makefile" ] && [ -f "$dir/makefile" ] && install_command make && make $dir
  done;
}

install_package(){
  if ! command_exists "$cmd" ; then
    install_dir $1
  fi
  dotfiles_dir $1/dotfiles $(basename -- $1);
  dotfiles_dir $1/$OS/dotfiles $(basename -- $1);
  [ -r $REPO_DIR/dotfiles/.rc ] && [ -f $REPO_DIR/dotfiles/.rc ] && . $REPO_DIR/dotfiles/.rc
  post_install_dir $1;
}

post_install_dir(){
  include $1/post-install.sh $1/$OS.post-install.sh $1/$OS/post-install.sh
}


recursive_install_packages(){

  if [ -r "$1/packages" ] && [ -d "$1/packages" ]; then
    for package_dir in $1/packages/* ; do
      recursive_install $package_dir
    done;
  fi
  if [ -r "$1/$OS/packages" ] && [ -d "$1/$OS/packages" ]; then
    for package_dir in $1/$OS/packages/* ; do
      recursive_install $package_dir
    done;
  fi
}

recursive_install(){
  install_package $1;
  recursive_install_packages $1;
}

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `bootstrap.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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
sudo chown -R $(id -unr):$(id -gnr) $GIT_ARCHIVE

if [ -z "$DOTFILES" ]; then
  export DOTFILES="$USR_SRC/dotfiles";
fi
sudo mkdir -p $DOTFILES
sudo chown -R $(id -unr):$(id -gnr) $DOTFILES

GIT_DOMAIN_USERNAME_REPONAME="github.com/tarranjones/setup" #try to create dynamically
REPO_DIR="$GIT_ARCHIVE/$GIT_DOMAIN_USERNAME_REPONAME"
OS=$( uname -s | tr '[:upper:]' '[:lower:]')
OS_DIR=$REPO_DIR/$OS
APP_DIR=$REPO_DIR/applications
OS_APP_DIR=$OS_DIR/applications

# sudo chown -R $(id -u):$(id -g) "$(git rev-parse --show-toplevel)/.git/"

# if [ -r "$REPO_DIR/.git" ] && [ -d "$REPO_DIR/.git" ]; then
#   sudo chown -R $USER $REPO_DIR/.git/
# fi
# if ! git -C $REPO_DIR pull 2>/dev/null ; then
#     sudo rm -rf $REPO_DIR
#     sudo git clone https://$GIT_DOMAIN_USERNAME_REPONAME.git $REPO_DIR
#     sudo chown -R $USER $REPO_DIR/.git/
# fi

# sudo git -C $REPO_DIR submodule update --init --recursive --remote --merge

# COPY DEVELOPMENT VERSION TO REPO_DIR (INSTEAD OF OUTOFDATE GIT REPO)
#############################################


absolute_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )

dev_dotfiles=$(dirname $absolute_path)/dotfiles

sudo rm -fr $REPO_DIR/
sudo mkdir -p $REPO_DIR
sudo cp -Rf $absolute_path/ $REPO_DIR/
sudo rm -fr  $REPO_DIR/dotfiles
sudo cp -Rf $dev_dotfiles/ $REPO_DIR/dotfiles

sudo chown -R $(id -unr):$(id -gnr) $REPO_DIR

cd $REPO_DIR # just so we dont do anything to the dev directory
##############################################


rm -fr  $DOTFILES

[ -r $REPO_DIR/dotfiles/.env ] && [ -f $REPO_DIR/dotfiles/.env ] && . $REPO_DIR/dotfiles/.env
[ -r $REPO_DIR/dotfiles/.functions ] && [ -f $REPO_DIR/dotfiles/.functions ] && . $REPO_DIR/dotfiles/.functions

install_system(){
  install_dir $REPO_DIR;
  dotfiles_dir "$REPO_DIR/dotfiles" ""
  dotfiles_dir "$REPO_DIR/$OS/dotfiles" "" $OS
  [ -r $REPO_DIR/dotfiles/.rc ] && [ -f $REPO_DIR/dotfiles/.rc ] && . $REPO_DIR/dotfiles/.rc
  post_install_dir $REPO_DIR;
  recursive_install_packages $REPO_DIR
}
install_system


exit;

# run last may require composer, git, npm to pull dotfiles
[ -r $REPO_DIR/dotfiles/bootstrap.sh ] && [ -f $REPO_DIR/dotfiles/bootstrap.sh ] && . $REPO_DIR/dotfiles/bootstrap.sh

# source $DOTFILES/.rc



