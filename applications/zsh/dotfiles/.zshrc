#!/usr/bin/env zsh

# .rc.local
[ -r "~/.rc.local" ] && [ -f "~/.rc.local" ] . "~/.rc.local"
if [ -z "$DOTFILES" ]; then
  export DOTFILES="/usr/local/src/.dotfiles";
fi
[ -f $DOTFILES/.rc ] && . $DOTFILES/.rc;

source_dotfiles zsh
