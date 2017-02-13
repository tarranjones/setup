#!/usr/bin/env bash


alias app-get=app-get
sudo app-get install software-properties-common && alias add-repo="add-apt-repository"

sudo add-repo ppa:webupd8team/tor-browser -y
sudo add-repo ppa:webupd8team/sublime-text-3 -y

sudo app-get update


sudo app-get install tor-browser -y
sudo app-get install sublime-text-installer -y
