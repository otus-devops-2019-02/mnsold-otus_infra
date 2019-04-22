#!/bin/bash
set -e

#set repo mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

#install mongodb
sudo apt update
sudo apt install -y mongodb-org

#configure ip listener
sudo sed -i 's/bindIp:[[:blank:]]*127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

#enable and start mongodb
sudo systemctl enable mongod
#sudo systemctl start mongod  #disable for packer

#check
#sudo systemctl status mongod
