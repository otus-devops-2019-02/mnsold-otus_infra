#!/bin/bash


#clone app
cd && git clone -b monolith https://github.com/express42/reddit.git

#install ref of app
cd ~/reddit && bundle install
