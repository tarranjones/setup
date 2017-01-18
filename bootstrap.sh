#!/usr/bin/env bash

# this should be a makfile but for simplicity just run as a shell script

# all these functions should be in the makefile



application_installed(){

  command -v "$1" >/dev/null 2>&1
}

add_dotfiles(){

  if [ -r "$1/dotfiles" ] && [ -d "$1/dotfiles" ]; then

    bsname=$(basename $1)

    if [ "$bsname" == "$OS" ]; then

      for file in $1/dotfiles/.[^.]* ; do

        sudo mkdir -p "$DOTFILES/$(basename $(dirname "$1"))"
        sudo ln -sf $file $DOTFILES/$(basename $(dirname "$1"))/.$bsname$(basename "$file")

      done;

    else
      sudo mkdir -p "$DOTFILES/$bsname"
      sudo ln -sf $1/dotfiles/.[^.]* $DOTFILES/$bsname/
    fi

  fi

}
run_install_scripts(){

  include "$1/pre-install.sh" "$1/install.sh" "$1/post-install.sh"
  # npm install
  # composer install
}
install_application(){

  if ! application_installed "$(basename "$1")";  then
    run_install_scripts "$1"
  fi
    add_dotfiles "$1"


  # if installed else add remove

}

# su - $USER

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
fi
sudo mkdir -p $DOTFILES

GIT_DOMAIN_USERNAME_REPONAME="github.com/tarranjones/setup" #try to create dynamically

REPO_DIR="$GIT_ARCHIVE/$GIT_DOMAIN_USERNAME_REPONAME"

OS=$( uname -s | tr '[:upper:]' '[:lower:]')

PLATFORM_APPLICATIONS=$REPO_DIR/platform/$OS/applications

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
sudo rm -r $DOTFILES;
# sudo ln -sf "$DOTFILE_DIRNAME" $DOTFILES

# symlink files not dir
sudo mkdir -p $DOTFILES

sudo ln -sf $DOTFILE_DIRNAME/.[^.]*  $DOTFILES/

#Run OS install preferences/ defaults
run_install_scripts "$REPO_DIR/platfrom/$OS"

#Add OS dotfiles .darwin.functions
for file in $REPO_DIR/platform/$OS/dotfiles/.[^.]* ; do

  sudo ln -sf $file $DOTFILES/.$OS$(basename $file)

done;

#single $OS only Applicaions - system package managers, terminals etc- homebrew, linuxbrew, Chocolatey, iterm, babun, scoop)
#kept seperate because they most likely need installing first
for app_dir in $PLATFORM_APPLICATIONS/* ; do

  if [ -r "$app_dir" ] && [ -d "$app_dir" ]; then

    install_application "$app_dir";

  fi

done;

for app_dir in $REPO_DIR/applications/* ; do

  if [ -r "$app_dir" ] && [ -d "$app_dir" ]; then

    #cross platform install
    install_application "$app_dir";

    if [ -r "$app_dir/$OS" ] && [ -d "$app_dir/$OS" ]; then

      # platform specific install
      install_application "$app_dir/$OS";
    fi

  fi

done;
