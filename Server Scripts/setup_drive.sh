#!/bin/bash

# Script to set up drive integration
echo "Starting to set up Google Drive integration in 5 seconds..."
sleep 5

if [ ! -d "$HOME/bin/go" ]
then
  echo "Setting up go lang..."
  cd ~/bin
  wget https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz
  tar -xzvf go1.13.5.linux-amd64.tar.gz
  mkdir -p $HOME/bin/go/packages
  rm go1.13.5.linux-amd64.tar.gz
  echo "export GOROOT=\$HOME/bin/go" >> ~/.bash_profile
  echo "export GOPATH=\$GOROOT/packages" >> ~/.bash_profile
  echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi

if [ ! -d "$HOME/GoogleDrive" ]
then
    echo "Setting up drive utility..."
    go get -u -v github.com/odeke-em/drive/cmd/drive
    mkdir -p ~/GoogleDrive/
    cd ~/GoogleDrive/
    drive init
    drive pull -depth 2 -no-prompt -verbose
fi