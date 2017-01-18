#!/usr/bin/env bash
# ~/.bashrc
#is read if the shell is not a login shell.
#is read if the shell is interactive.


# handle bash files only
#.rc should handle all other files

DOTFILES="/usr/local/src/.dotfiles";
[ -f $DOTFILES/.rc ] && . $DOTFILES/.rc;

source_dotfiles bash
