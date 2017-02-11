#!/usr/bin/env bash
sudo app-get install software-properties-common
sudo add-repo ppa:webupd8team/sublime-text-3 -y
sudo app-get update
sudo app-get install sublime-text-installer -y
