#!/bin/bash

#install ruby/bundler
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

#set repo mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

#install mongodb
sudo apt update
sudo apt install -y mongodb-org

#enable and start mongodb
sudo systemctl enable mongod
sudo systemctl start mongod

#clone app
cd ~appuser && git clone -b monolith https://github.com/express42/reddit.git

#install ref of app
cd ~appuser/reddit && bundle install

#deploy app
cd ~appuser/reddit && chown -R appuser ~appuser/reddit && puma -d