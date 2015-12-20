#!/bin/bash

echo "Install Mono Repo"
echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" | sudo tee -a /etc/apt/sources.list.d/mono-xamarin.list

echo "Installing required packages"
sudo apt-get install make unrar unzip autoconf automake libtool gcc g++ gperf \
  flex bison texinfo gawk ncurses-dev libexpat-dev python python-serial \
  sed git gcc-multilib g++-multilib mono-complete \
  -y