#!/usr/bin/env bash

brew install bash
# Add the new shell to the list of legit shells
sudo bash -c "echo /usr/local/bin/bash >> /private/etc/shells"
# appendtofile "/usr/local/bin/bash" /private/etc/shells
chsh -s /usr/local/bin/bash  $USER
