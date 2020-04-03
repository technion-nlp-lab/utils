#!/bin/bash

if [ ! -d "$HOME/anaconda3/" ]
then
  echo "Conda Environments Setup"
  mkdir -p ~/bin
  cd ~/bin
  wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
  bash Anaconda3-2019.10-Linux-x86_64.sh
  echo "alias 'conda_env'='source \$HOME/anaconda3/etc/profile.d/conda.sh'" >> ~/.bash_profile
  # Make sure this script is actually safe to erase
  rm Anaconda3-2019.10-Linux-x86_64.sh
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
echo "export LC_ALL=en_US.UTF-8" >> ~/.bash_profile
echo "export LANG=en_US.UTF-8" >> ~/.bash_profile