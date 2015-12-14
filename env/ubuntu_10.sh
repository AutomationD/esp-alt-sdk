#!/bin/bash

echo "Installing required packages"
sudo apt-get install make unrar unzip autoconf automake libtool gcc g++ gperf \
  flex bison texinfo gawk ncurses-dev libexpat-dev python python-serial \
  sed git gcc-multilib g++-multilib \
  -y