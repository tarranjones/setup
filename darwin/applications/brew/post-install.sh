#!/usr/bin/env bash

brew tap caskroom/cask

brew cask install iterm2

# https://github.com/sindresorhus/guides/blob/master/how-not-to-rm-yourself.md#safeguard-rm
brew install coreutils

# // fix sed on osx
# brew bundle check

# limechat


### Applications hat should not be installed with brew ###

# nvm - requires manual config anyway (PATH , mkdir etc)

