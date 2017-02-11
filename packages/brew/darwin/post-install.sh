#!/usr/bin/env bash

brew tap caskroom/cask

brew cask install iterm2

# https://github.com/sindresorhus/guides/blob/master/how-not-to-rm-yourself.md#safeguard-rm
brew install coreutils

brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package quicklookase qlvideo 2> /dev/null

# brew cask install "${@}" 2> /dev/null

# // fix sed on osx
# brew bundle check

# limechat


### Applications hat should not be installed with brew ###

# nvm - requires manual config anyway (PATH , mkdir etc)

