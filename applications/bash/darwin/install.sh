#!/usr/bin/env bash

brew install bash
sudo -s
echo /usr/local/bin/bash >> /etc/shells
chsh -s /usr/local/bin/bash
chsh -s /usr/local/bin/bash  $USER
