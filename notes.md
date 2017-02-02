


<!-- setup -->

make usr/local/.dotfile


symlink bash/.dotfile/ .dotfile/bash






system

setup poxis terminal
else
create vm and config to run automatially + ssh to vm automatically + treat $home as vm $home


installation type priority

application level package mangers cli's
https://en.wikipedia.org/wiki/List_of_software_package_management_systems#Application-level_package_managers

{
  "avm" : {
    "ruby" : ["rvm"],
    "nodejs" : ["nvm"]
  },
  "apm" : {
    "php" : ["composer"],
    "nodejs" : ["npm", "yarn"],
    "python" : ["easy_install", "pip"],
    "ruby" : ["bundler", "gem"],
    "vim" : ["vundle"],
    "zsh" : ["antigen"],
    "composer" : {
      "update"
    }
  }
}

. avm's - application level version managers - nvm, rvm.
. apm's - application level package managers - npm, bundler, yarn, pip, antigen

. pvm's - package version managers
. antigen(sh), composer(php), {npm, yarn}(nodejs), {easy_install, pip}(python), {bundler, gem}(ruby,
. curl -s https://example.com/install.sh | sh - use ssl and hash checksum where possible
. system package managers
. build from source

install application using hightest ranking method
update, uninstall via selfupdate if possible else use hightest ranking method
