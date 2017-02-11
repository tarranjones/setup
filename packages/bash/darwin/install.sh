#!/usr/bin/env bash

# brew uninstall --force bash
brew install bash

BASHPATH=$(brew --prefix)/bin/bash
#sudo echo $BASHPATH >> /etc/shells

appendtofile $(brew --prefix)/bin/bash /etc/shells
# sudo bash -c 'echo $(brew --prefix)/bin/bash >> /etc/shells'
chsh -s $BASHPATH # will set for current user only.
echo $BASH_VERSION # should be 4.x not the old 3.2.X
# Later, confirm iterm settings aren't conflicting.
