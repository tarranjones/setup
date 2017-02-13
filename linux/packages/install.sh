#!/usr/bin/env bash

# Add Repos 
sudo add-repo ppa:webupd8team/tor-browser -y
sudo add-repo ppa:webupd8team/sublime-text-3 -y

#Update 
sudo app-get update

#Install
sudo app-get install tor-browser -y
sudo app-get install sublime-text-installer -y
