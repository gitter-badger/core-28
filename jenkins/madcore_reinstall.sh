#!/bin/bash

#delete docker containers and images
sudo docker stop $(docker ps -q)
sudo docker rm -f $(docker ps -a -q)
sudo docker rmi -f $(docker images -q)

#copy certs
sudo mkdir -p /opt/backup/certs
cp -R /opt/certs /opt/backup/certs

#copy redis base
mkdir /opt/backup/redis
cp /hab/svc/redis/data/dump.rdb /opt/backup/redis/

#copy registry base
mkdir /opt/backup/dockerstorage
cp -R /opt/dockerstorage /opt/backup/dockerstorage

#delete files
sudo rm -rf /opt/auth
sudo rm -rf /opt/bin
sudo rm -rf /opt/certs
sudo rm -rf /opt/controlbox
sudo rm -rf /opt/dockerstorage
sudo rm -rf /opt/haproxy
sudo rm -rf /opt/heapster
sudo rm -rf /opt/kubernetes


#start new installation
sudo mkdir -p /opt/controlbox
sudo chown ubuntu:ubuntu /opt/controlbox
git clone https://bitbucket.org/ronaanimation/controlbox.git /opt/controlbox
sudo chmod +x /opt/controlbox/cb-install.sh
sudo "/opt/controlbox/cb-install.sh"

#restore dockerstorage
sudo mv /opt/backup/dockerstorage /opt/dockerstorage
sudo docker stop registrydocker_registry_1
sudo sudo systemctl start docker-compose

#restore certs
sudo mv /opt/backup/certs /opt/certs
sudo service haproxy restart