#!/bin/bash
set -e

#install ruby/bundler
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

#check install
#ruby -v
#bundler -v
