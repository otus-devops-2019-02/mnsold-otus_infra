#!/bin/bash

#add service
sudo cp /tmp/reddit.service /etc/systemd/system/reddit.service
sudo systemctl daemon-reload

# enable service
sudo systemctl enable reddit
#sudo systemctl start reddit
