#!/usr/bin/env bash
# ~/.bashrc
#is read if the shell is not a login shell.
#is read if the shell is interactive.


# handle bash files only
#.rc should handle all other files

# .rc.local
[ -r "~/.rc.local" ] && [ -f "~/.rc.local" ] . "~/.rc.local"
if [ -z "$DOTFILES" ]; then
  export DOTFILES="/usr/local/src/dotfiles";
fi
[ -f $DOTFILES/.rc ] && . $DOTFILES/.rc;

source_dotfiles bash
